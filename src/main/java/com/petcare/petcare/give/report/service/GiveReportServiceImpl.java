/**
 * 역할: GiveReportService 구현체 (@Service)
 *
 * - 박유정 / 2026-07-06~07
 *
 * [insertReport — 등록]
 * 1. 세션 회원 → TB_MEMBER 조회 후 MEMBER_NO 세팅
 * 2. 폼 값 조합(제목·본문·특징·태그) → TB_POST INSERT
 * 3. savePhotos() → C:/upload/give/report/{postId}/ 저장 + TB_FILE INSERT
 *
 * [getReportList — 목록]
 * 1. TB_POST 목록 조회 (BOARD_TYPE='LOST', STATUS_CD='ACTIVE')
 * 2. 각 글마다 TB_FILE 첫 사진 → thumbUrl
 *
 * [getReportDetail — 상세]
 * 1. TB_POST 1건 조회
 * 2. TB_FILE 사진 URL 목록 → photoUrls
 *
 * 연결
 * - implements: GiveReportService
 * - 사용: GiveReportMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.give.report.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.give.report.mapper.GiveReportMapper;
import com.petcare.petcare.give.report.vo.GiveReportFileVO;
import com.petcare.petcare.give.report.vo.GiveReportVO;
import com.petcare.petcare.member.vo.MemberVO;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class GiveReportServiceImpl implements GiveReportService {

    // 디비에 접근할 우체부(Mapper) 필드 선언 (final로 안전하게 박제)
    private final GiveReportMapper giveReportMapper;

    @Value("${file.upload-dir}")
    private String uploadDir; // application.properties → C:/upload/

    private static final int MAX_PHOTOS = 5; // write.jsp 최대 5장과 동일

    // 2. 생성자 주입 
    public GiveReportServiceImpl(GiveReportMapper giveReportMapper) {
        this.giveReportMapper = giveReportMapper;
    }

    @Override
    public void insertReport(GiveReportVO vo, MemberVO loginMember, MultipartFile[] photos) {
        resolveMemberNo(vo, loginMember);
        // 1) DB에 꼭 필요한 고정값
        vo.setBoardType("LOST");
        vo.setStatusCd("ACTIVE");
        // 2) 제목·본문·특징 등 조합 
        vo.setTitle(buildTitle(vo));
        vo.setBody(buildBody(vo));
        vo.setLostFeature(truncate(buildLostFeature(vo), 500));
        vo.setTags(truncate(buildTags(vo), 500));
        vo.setRegion(truncate(extractRegion(vo.getAddress()), 50));
        // 3) 위도·경도 없으면 기본값 (지도 연동 전)
        if (vo.getLostLat() == null) {
            vo.setLostLat(37.5665);
        }
        if (vo.getLostLng() == null) {
            vo.setLostLng(126.9780);
        }
        // 4) DB INSERT
        giveReportMapper.insertReport(vo);
        // 5) 사진 로컬 저장 + TB_FILE
        savePhotos(vo.getPostId(), photos);
    }
    // ── 아래는 private 헬퍼 메서드 (같은 클래스 안에 추가) ──
    private String buildTitle(GiveReportVO vo) {
        String kind = "FOUND".equals(vo.getReportKind()) ? "발견" : "분실";
        String species = toSpeciesLabel(vo.getLostSpecies());
        String region = extractRegion(vo.getAddress());
        if (region.isEmpty()) {
            region = "위치 미입력";
        }
        return "[" + kind + "] " + region + " " + species;
    }
    private String buildBody(GiveReportVO vo) {
        StringBuilder sb = new StringBuilder();
        if (vo.getFoundAt() != null && !vo.getFoundAt().isBlank()) {
            sb.append("[발견·분실 일시] ").append(vo.getFoundAt()).append("\n");
        }
        if (vo.getAddress() != null && !vo.getAddress().isBlank()) {
            sb.append("[주소] ").append(vo.getAddress()).append("\n");
        }
        sb.append("[임시보호] ")
          .append("Y".equalsIgnoreCase(vo.getTempCare()) ? "예" : "아니요")
          .append("\n\n");
        if (vo.getDescription() != null) {
            sb.append(vo.getDescription());
        }
        return sb.toString().trim();
    }
    private String buildLostFeature(GiveReportVO vo) {
        return safe(vo.getAnimalSize()) + "|"
             + safe(vo.getFurColor()) + "|"
             + safe(vo.getGender()) + "|"
             + safe(vo.getFeatureTags());
    }
    private String buildTags(GiveReportVO vo) {
        String kind = (vo.getReportKind() == null || vo.getReportKind().isBlank())
                ? "FOUND" : vo.getReportKind();
        String tags = kind + ",FINDING";
        if ("Y".equalsIgnoreCase(vo.getTempCare())) {
            tags += ",TEMP_CARE";
        }
        return tags;
    }
    private String extractRegion(String address) {
        if (address == null || address.isBlank()) {
            return "";
        }
        String trimmed = address.trim();
        return trimmed.length() > 50 ? trimmed.substring(0, 50) : trimmed;
    }
    private String toSpeciesLabel(String species) {
        if (species == null) return "동물";
        return switch (species) {
            case "DOG" -> "강아지";
            case "CAT" -> "고양이";
            case "ETC" -> "기타";
            default -> species;
        };
    }
    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private void resolveMemberNo(GiveReportVO vo, MemberVO loginMember) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }
        Long memberNo = lookupMemberNo(loginMember);
        if (memberNo == null) {
            throw new IllegalStateException("MEMBER_NOT_FOUND");
        }
        vo.setMemberNo(memberNo);
    }

    private Long lookupMemberNo(MemberVO loginMember) {
        if (loginMember.getMemberId() != null && !loginMember.getMemberId().isBlank()) {
            Long no = giveReportMapper.selectMemberNoByMemberId(loginMember.getMemberId().trim());
            if (no != null) {
                return no;
            }
        }
        if (loginMember.getEmail() != null && !loginMember.getEmail().isBlank()) {
            return giveReportMapper.selectMemberNoByEmail(loginMember.getEmail().trim());
        }
        return null;
    }

    private String truncate(String value, int maxLen) {
        if (value == null || value.length() <= maxLen) {
            return value;
        }
        return value.substring(0, maxLen);
    }

    @Override
    public GiveReportVO getReportDetail(long postId) {
        GiveReportVO report = giveReportMapper.selectReportDetail(postId);
        if (report != null) {
            // TB_FILE에서 사진 URL 목록 조회 → detail.jsp photoUrls
            report.setPhotoUrls(giveReportMapper.selectFileUrlsByPostId(postId));
        }
        return report;
    }

    @Override
    public List<GiveReportVO> getReportList() {
        List<GiveReportVO> list = giveReportMapper.selectReportList();
        for (GiveReportVO item : list) {
            // 첫 번째 사진을 목록 썸네일로 사용 → list.jsp thumbUrl
            List<String> urls = giveReportMapper.selectFileUrlsByPostId(item.getPostId());
            if (urls != null && !urls.isEmpty()) {
                item.setThumbUrl(urls.get(0));
            }
        }
        return list;
    }

    /**
     * 사진을 로컬 디스크에 저장하고 TB_FILE에 메타데이터 INSERT
     * 저장 경로: {uploadDir}/give/report/{postId}/{uuid}.ext
     * 접근 URL:  /upload/give/report/{postId}/{uuid}.ext (WebConfig 정적 매핑)
     */
    private void savePhotos(Long postId, MultipartFile[] photos) {
        if (postId == null || photos == null) {
            return;
        }
        Path dir = Paths.get(uploadDir, "give", "report", String.valueOf(postId));
        try {
            Files.createDirectories(dir);
        } catch (IOException e) {
            throw new IllegalStateException("UPLOAD_DIR_FAILED", e);
        }

        int saved = 0;
        for (MultipartFile file : photos) {
            if (file == null || file.isEmpty()) {
                continue;
            }
            if (saved >= MAX_PHOTOS) {
                break;
            }
            String savedName = UUID.randomUUID() + resolveExtension(file.getOriginalFilename());
            Path target = dir.resolve(savedName);
            try {
                file.transferTo(target);
            } catch (IOException e) {
                throw new IllegalStateException("FILE_SAVE_FAILED", e);
            }

            String fileUrl = "/upload/give/report/" + postId + "/" + savedName;
            GiveReportFileVO fileVo = new GiveReportFileVO();
            fileVo.setRefType("POST");
            fileVo.setRefId(postId);
            fileVo.setDriveFileId("LOCAL");
            fileVo.setFileUrl(fileUrl);
            fileVo.setOriginName(file.getOriginalFilename());
            giveReportMapper.insertFile(fileVo);
            saved++;
        }
    }

    /** 원본 파일명에서 확장자 추출 (jpg/png/gif/webp만 허용, 없으면 .jpg) */
    private String resolveExtension(String originalName) {
        if (originalName == null) {
            return ".jpg";
        }
        int dot = originalName.lastIndexOf('.');
        if (dot < 0) {
            return ".jpg";
        }
        String ext = originalName.substring(dot).toLowerCase();
        if (ext.matches("\\.(jpg|jpeg|png|gif|webp)")) {
            return ext;
        }
        return ".jpg";
    }
}

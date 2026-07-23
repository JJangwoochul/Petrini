/**
 * 역할: CommunityPostService 구현체 (@Service)
 *
 * - 박유정 / 2026-07-08~10
 *
 * [getPostList — 목록]
 * 1. boardType·keyword·page 로 TB_POST 조회 (5건/페이지)
 * 2. 각 글의 첫 사진 URL → thumbUrl
 * 3. LIFE + ANSWERED → 첫 일반댓글 답변 미리보기 (2026-07-10 STEP 4)
 *
 * [getPostDetail — 상세]
 * 1. increaseViewCount() → VIEW_COUNT +1
 * 2. TB_POST 1건 + photoUrls 목록
 *
 * [insertPost — 등록]
 * 1. 로그인 회원 → MEMBER_NO
 * 2. TB_POST INSERT (SEQ_TB_POST)
 * 3. 사진 로컬 저장(C:/upload/) + TB_FILE INSERT (최대 5장)
 * 4. LIFE 등록 시 TAGS = WAITING (2026-07-10)
 *
 * [markLifeAnswered — LIFE 답변완료] 2026-07-10 STEP 4
 * 1. BOARD_TYPE = LIFE 인지 확인
 * 2. updatePostTags(postId, "ANSWERED")
 *
 * 참고 테이블
 * - TB_POST, TB_FILE (REF_TYPE = 'POST')
 */

package com.petcare.petcare.community.post.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import com.petcare.petcare.give.report.vo.GiveReportFileVO;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.community.comment.service.CommunityCommentService;
import com.petcare.petcare.community.comment.vo.CommunityCommentVO;
import com.petcare.petcare.community.post.mapper.CommunityPostMapper;
import com.petcare.petcare.community.post.vo.CommunityPostVO;
import com.petcare.petcare.member.vo.MemberVO;

@Service
public class CommunityPostServiceImpl implements CommunityPostService {

    private final CommunityPostMapper communityPostMapper;
    private final CommunityCommentService communityCommentService;

    @Value("${file.upload-dir}")
    private String uploadDir;

    private static final int MAX_PHOTOS = 5;
    private static final int PAGE_SIZE = 5;

    public CommunityPostServiceImpl(
            CommunityPostMapper communityPostMapper,
            CommunityCommentService communityCommentService) {
        this.communityPostMapper = communityPostMapper;
        this.communityCommentService = communityCommentService;
    }

    @Override
    public List<CommunityPostVO> getPostList(
            String boardType, String keyword, int page, String petSpecies, String vetStatus) {
        String searchKeyword = normalizeKeyword(keyword);
        String species = normalizeLifeFilter(petSpecies);
        String status = normalizeVetStatus(vetStatus);
        int pageNo = Math.max(page, 1);
        int offset = (pageNo - 1) * PAGE_SIZE;
        List<CommunityPostVO> list = communityPostMapper.selectPostList(
                boardType, searchKeyword, species, status, offset, PAGE_SIZE);

        for (CommunityPostVO item : list) {
            List<String> urls = communityPostMapper.selectFileUrlsByPostId(item.getPostId());
            if (urls != null && !urls.isEmpty()) {
                item.setThumbUrl(urls.get(0));
            }
            attachLifeAnswerPreview(item);
        }
        return list;
    }

    @Override
    public int getPostCount(String boardType, String keyword, String petSpecies, String vetStatus) {
        return communityPostMapper.selectPostCount(
                boardType, normalizeKeyword(keyword), normalizeLifeFilter(petSpecies), normalizeVetStatus(vetStatus));
    }

    @Override
    public int getTotalPages(String boardType, String keyword, String petSpecies, String vetStatus) {
        int totalCount = getPostCount(boardType, keyword, petSpecies, vetStatus);
        if (totalCount == 0) {
            return 1;
        }
        return (int) Math.ceil(totalCount / (double) PAGE_SIZE);
    }

    private String normalizeLifeFilter(String value) {
        if (value == null || value.isBlank()) {
            return "";
        }
        return switch (value.trim().toUpperCase()) {
            case "DOG", "CAT", "ETC" -> value.trim().toUpperCase();
            default -> "";
        };
    }

    private String normalizeVetStatus(String value) {
        if (value == null || value.isBlank()) {
            return "";
        }
        return switch (value.trim().toUpperCase()) {
            case "WAITING", "ANSWERED" -> value.trim().toUpperCase();
            default -> "";
        };
    }

    private String normalizeKeyword(String keyword) {
        if (keyword == null) {
            return "";
        }
        return keyword.trim();
    }

    private void attachLifeAnswerPreview(CommunityPostVO item) {
        // LIFE 목록 — ANSWERED 글에 vet-answer 미리보기 데이터 첨부 / 2026-07-10 STEP 4
        if (item == null || item.getPostId() == null) {
            return;
        }
        if (!"LIFE".equalsIgnoreCase(item.getBoardType())) {
            return;
        }
        String tags = item.getTags();
        if (tags == null || !tags.contains("ANSWERED")) {
            return;
        }
        CommunityCommentVO answer = communityCommentService.getFirstTopComment(item.getPostId());
        if (answer == null) {
            return;
        }
        item.setAnswerBody(answer.getBody());
        item.setAnswerAuthor(answer.getNickname());
        item.setAnswerDate(answer.getRegDate());
    }

    @Override
    public CommunityPostVO getPostDetail(long postId) {
        CommunityPostVO post = communityPostMapper.selectPostDetail(postId);
        if (post == null) {
            return null;
        }
        communityPostMapper.increaseViewCount(postId);
        post.setPhotoUrls(communityPostMapper.selectFileUrlsByPostId(postId));
        return post;
    }

    @Override
    public void insertPost(CommunityPostVO vo, MemberVO loginMember, MultipartFile[] photos) {
        resolveMemberNo(vo, loginMember);

        vo.setStatusCd("ACTIVE");
        if (vo.getRegion() == null) {
            vo.setRegion("");
        }
        if (vo.getTags() == null) {
            vo.setTags("");
        }
        if (vo.getLostSpecies() == null) {
            vo.setLostSpecies("");
        }
        if (vo.getLostFeature() == null) {
            vo.setLostFeature("");
        }

        if ("LIFE".equalsIgnoreCase(vo.getBoardType())) {
            vo.setLostSpecies(normalizePetType(vo.getPetType()));
            vo.setLostFeature(buildPetFeature(vo.getBreed(), vo.getPetAge()));
            vo.setTags("WAITING");  // LIFE 상담 등록 시 답변대기 / 2026-07-10
        }

        communityPostMapper.insertPost(vo);
        savePhotos(vo.getPostId(), photos);
    }

    private String normalizePetType(String petType) {
        if (petType == null || petType.isBlank()) {
            return "";
        }
        return switch (petType.trim().toUpperCase()) {
            case "DOG", "CAT", "ETC" -> petType.trim().toUpperCase();
            default -> "";
        };
    }

    private String buildPetFeature(String breed, String petAge) {
        String b = breed == null ? "" : breed.trim();
        String a = petAge == null ? "" : petAge.trim();
        return b + "|" + a;
    }

    private void resolveMemberNo(CommunityPostVO vo, MemberVO loginMember) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }
        if (loginMember.getMemberNo() != null) {
            vo.setMemberNo(loginMember.getMemberNo());
            return;
        }
        Long memberNo = lookupMemberNo(loginMember);
        if (memberNo == null) {
            throw new IllegalStateException("MEMBER_NOT_FOUND");
        }
        vo.setMemberNo(memberNo);
    }

    private Long lookupMemberNo(MemberVO loginMember) {
        if (loginMember.getMemberId() != null && !loginMember.getMemberId().isBlank()) {
            Long no = communityPostMapper.selectMemberNoByMemberId(loginMember.getMemberId().trim());
            if (no != null) {
                return no;
            }
        }
        if (loginMember.getEmail() != null && !loginMember.getEmail().isBlank()) {
            return communityPostMapper.selectMemberNoByEmail(loginMember.getEmail().trim());
        }
        return null;
    }

    private void savePhotos(Long postId, MultipartFile[] photos) {
        if (postId == null || photos == null) {
            return;
        }

        Path dir = Paths.get(uploadDir, "community", "post", String.valueOf(postId));
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

            String fileUrl = "/upload/community/post/" + postId + "/" + savedName;
            GiveReportFileVO fileVo = new GiveReportFileVO();
            fileVo.setRefType("POST");
            fileVo.setRefId(postId);
            fileVo.setDriveFileId("LOCAL");
            fileVo.setFileUrl(fileUrl);
            fileVo.setOriginName(file.getOriginalFilename());
            communityPostMapper.insertFile(fileVo);
            saved++;
        }
    }

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

    @Override
    public void markLifeAnswered(long postId) {
        // LIFE + 일반댓글 등록 후 TAGS → ANSWERED / 2026-07-10 STEP 4
        CommunityPostVO post = communityPostMapper.selectPostDetail(postId);
        if (post == null || !"LIFE".equalsIgnoreCase(post.getBoardType())) {
            return;
        }
        communityPostMapper.updatePostTags(postId, "ANSWERED");
    }

    /**
     * 2026-07-23 HYJ — 게시글 수정 (본인 글만)
     * 1. 로그인 확인 → MEMBER_NO 매칭
     * 2. UPDATE TB_POST SET TITLE, BODY WHERE POST_ID AND MEMBER_NO
     */
    @Override
    public void updatePost(CommunityPostVO vo, MemberVO loginMember) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }
        Long loginMemberNo = resolveMemberNoForUpdate(loginMember);
        if (loginMemberNo == null) {
            throw new IllegalStateException("MEMBER_NOT_FOUND");
        }

        CommunityPostVO existing = communityPostMapper.selectPostDetail(vo.getPostId());
        if (existing == null) {
            throw new IllegalArgumentException("POST_NOT_FOUND");
        }
        if (!loginMemberNo.equals(existing.getMemberNo())) {
            throw new IllegalStateException("FORBIDDEN");
        }

        vo.setMemberNo(loginMemberNo);
        int updated = communityPostMapper.updatePost(vo);
        if (updated == 0) {
            throw new IllegalStateException("UPDATE_FAILED");
        }
    }

    /**
     * 2026-07-23 HYJ — 게시글 삭제 (본인 글만)
     * - LIFE(수의사 상담): 소프트 삭제 → IS_DELETED='Y', DELETED_DATE=SYSDATE (기록 보관)
     * - TOWN/SHARE: 물리 삭제 → DELETE FROM TB_POST + TB_FILE
     */
    @Override
    public void deletePost(long postId, MemberVO loginMember) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }
        Long loginMemberNo = resolveMemberNoForUpdate(loginMember);
        if (loginMemberNo == null) {
            throw new IllegalStateException("MEMBER_NOT_FOUND");
        }

        CommunityPostVO existing = communityPostMapper.selectPostDetail(postId);
        if (existing == null) {
            throw new IllegalArgumentException("POST_NOT_FOUND");
        }
        if (!loginMemberNo.equals(existing.getMemberNo())) {
            throw new IllegalStateException("FORBIDDEN");
        }

        boolean isLife = "LIFE".equalsIgnoreCase(existing.getBoardType());
        int result;

        if (isLife) {
            // LIFE — 댓글·대댓글 소프트 삭제 → 게시글 소프트 삭제
            communityCommentService.softDeleteCommentsByPostId(postId);
            result = communityPostMapper.softDeletePost(postId, loginMemberNo);
        } else {
            // TOWN, SHARE — 댓글·대댓글 물리 삭제 → 파일 삭제 → 게시글 물리 삭제
            communityCommentService.hardDeleteCommentsByPostId(postId);
            communityPostMapper.deleteFilesByPostId(postId);
            result = communityPostMapper.hardDeletePost(postId, loginMemberNo);
        }

        if (result == 0) {
            throw new IllegalStateException("DELETE_FAILED");
        }
    }

    private Long resolveMemberNoForUpdate(MemberVO loginMember) {
        if (loginMember.getMemberNo() != null) {
            return loginMember.getMemberNo();
        }
        return lookupMemberNo(loginMember);
    }

    /**
     * 2026-07-23 HYJ — 소프트 삭제 후 N일 경과 데이터 완전 삭제 (스케줄러)
     * 삭제 순서: 댓글 → 파일 → 게시글 (FK 순서)
     */
    @Override
    public int purgeExpiredSoftDeletedPosts(int days) {
        List<Long> expiredPostIds = communityPostMapper.selectExpiredSoftDeletedPostIds(days);
        if (expiredPostIds == null || expiredPostIds.isEmpty()) {
            return 0;
        }

        int purged = 0;
        for (Long postId : expiredPostIds) {
            communityCommentService.hardDeleteCommentsByPostId(postId);
            communityPostMapper.deleteFilesByPostId(postId);
            int result = communityPostMapper.hardDeleteExpiredPost(postId);
            if (result > 0) {
                purged++;
            }
        }
        return purged;
    }
}

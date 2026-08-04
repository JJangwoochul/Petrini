/**
 * 역할: MypageAccountService 구현체 (@Service)
 *
 * - 2026-08-04 박유정 — 프로필 사진 로컬 저장 (C:/upload/member/profile/) + DB URL UPDATE
 */

package com.petcare.petcare.mypage.account.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.mypage.account.mapper.MypageAccountMapper;
import com.petcare.petcare.mypage.account.vo.MypageAccountVO;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;

@Service
public class MypageAccountServiceImpl implements MypageAccountService {

    private static final Logger log = LoggerFactory.getLogger(MypageAccountServiceImpl.class);

    private final MypageAccountMapper mypageAccountMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    @Value("${file.upload-dir}")
    private String uploadDir;   // application.properties → C:/upload/

    public MypageAccountServiceImpl(MypageAccountMapper mypageAccountMapper,
                                     BCryptPasswordEncoder passwordEncoder) {
        this.mypageAccountMapper = mypageAccountMapper;
        this.passwordEncoder = passwordEncoder;
    }

    // 2026-07-28 박유정 — 회원정보 수정 화면용 프로필 조회
    @Override
    @Transactional(readOnly = true)
    public MypageAccountVO getMemberProfile(Long memberNo) {
        if (memberNo == null) {
            return null;
        }
        return mypageAccountMapper.selectMemberProfile(memberNo);
    }

    // 2026-08-04 박유정 — 프로필 사진 저장 + DB URL UPDATE
    @Override
    @Transactional
    public String updateProfileImage(Long memberNo, MultipartFile file) {

    // 2026-08-04 박유정 — [1] 회원번호·파일 기본 검증
    if (memberNo == null) {
        throw new IllegalArgumentException("회원 정보가 없습니다.");
    }
    if (file == null || file.isEmpty()) {
        throw new IllegalArgumentException("업로드할 사진을 선택해 주세요.");
    }

    // 2026-08-04 박유정 — [2] 이미지 MIME 타입 검증
    String contentType = file.getContentType();
    if (contentType == null || !contentType.startsWith("image/")) {
        throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");
    }

    // 2026-08-04 박유정 — [3] 로컬 저장 (분실신고 사진과 동일 uploadDir 패턴)
    String savedName = UUID.randomUUID() + resolveExtension(file.getOriginalFilename());
    String objectPath = "member/profile/" + memberNo + "/" + savedName;
    String fileUrl = "/upload/" + objectPath;

    Path dir = Paths.get(uploadDir, "member", "profile", String.valueOf(memberNo));
    try {
        Files.createDirectories(dir);
        file.transferTo(dir.resolve(savedName));
    } catch (IOException e) {
        throw new IllegalStateException("FILE_SAVE_FAILED", e);
    }

    // 2026-08-04 박유정 — [4] TB_MEMBER.PROFILE_IMG_URL UPDATE
    MypageAccountVO vo = new MypageAccountVO();
    vo.setMemberNo(memberNo);
    vo.setProfileImgUrl(fileUrl);
    mypageAccountMapper.updateMemberProfile(vo);

    return fileUrl;
}

    /**
     * HYJ 26.07.29 회원 탈퇴
     * [1] DB 에서 암호화된 비밀번호 조회
     * [2] 입력된 비밀번호와 비교
     * [3] 일치하면 STATUS_CD = 'WITHDRAWN'
     * [4] INSERT INTO TB_MEMBER_WITHDRAW
     */
    @Override
    @Transactional
    public String withdraw(Long memberNo, String password) {

        String storedPwd = mypageAccountMapper.selectPasswordByMemberNo(memberNo);
        if (storedPwd == null) {
            return "회원 정보를 찾을 수 없습니다.";
        }

        if (!passwordEncoder.matches(password, storedPwd)) {
            return "비밀번호가 일치하지 않습니다.";
        }

        mypageAccountMapper.updateStatusToWithdrawn(memberNo);
        mypageAccountMapper.insertMemberWithdraw(memberNo);
        return null;
    }

    /**
     * HYJ 26.07.29 7일 경과 탈퇴 회원 개인정보 삭제
     *
     * 삭제 범위:
     * - TB_MEMBER: 개인정보 익명화 (이름, 이메일, 전화번호 등 → NULL)
     * - TB_MEMBER_SOCIAL: 소셜 연동 삭제
     * - TB_PET: 반려동물 정보 삭제
     * - TB_MEMBER_AGREEMENT: 약관 동의 기록 삭제
     * - TB_MEMBER_WITHDRAW: 탈퇴회원 관리(맨마지막)
     */
    @Override
    @Transactional
    public int purgeExpiredWithdrawnMembers() {

        List<Long> memberNos = mypageAccountMapper.selectExpiredWithdrawnMemberNos();

        if (memberNos.isEmpty()) {
            return 0;
        }

        for (Long memberNo : memberNos) {
            // 관련 테이블 먼저 삭제 (FK 순서)
            mypageAccountMapper.deleteSocialByMemberNo(memberNo);
            mypageAccountMapper.deletePetsByMemberNo(memberNo);
            mypageAccountMapper.deleteAgreementsByMemberNo(memberNo);
            // TB_MEMBER 익명화 (삭제가 아닌 NULL 처리)
            mypageAccountMapper.anonymizeMember(memberNo);

            //HYJ 26.07.29 TB_MEMBER FK참조하는 테이블 확인 후 추가 필요
            //....

            // TB_MEMBER_WITHDRAW (탈퇴회원관리테이블 삭제)
            mypageAccountMapper.deleteMemberWithdrawByMemberNo(memberNo);

            log.info("탈퇴 회원 개인정보 삭제 완료: MEMBER_NO={}", memberNo);
        }

        log.info("총 {}명의 탈퇴 회원 개인정보 삭제 완료", memberNos.size());
        return memberNos.size();
    }
    // 2026-08-04 박유정 — 업로드 파일 확장자 정규화 (.jpg/.jpeg/.png/.webp)
    private String resolveExtension(String originalName) {
        if (originalName == null) {
            return ".jpg";
        }
        int dot = originalName.lastIndexOf('.');
        if (dot < 0) {
            return ".jpg";
        }
        String ext = originalName.substring(dot).toLowerCase();
        if (".jpg".equals(ext) || ".jpeg".equals(ext) || ".png".equals(ext) || ".webp".equals(ext)) {
            return ext;
        }
        return ".jpg";
    }
}

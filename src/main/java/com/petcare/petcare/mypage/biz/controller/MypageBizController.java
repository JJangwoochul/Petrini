/**
 * 역할: 마이페이지 사업자 URL 처리 → Service 호출 → JSP/리다이렉트 반환
 *
 * 연결
 * - Service: MypageBizService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.biz.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.common.config.controller.CommonConfigController;
import com.petcare.petcare.file.mapper.FileMapper;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.member.auth.service.MemberAuthService;
import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.mypage.biz.service.MypageBizService;
import com.petcare.petcare.mypage.biz.vo.MypageBizVO;

import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/mypage/biz")
public class MypageBizController extends CommonConfigController {

    @Autowired
    private MypageBizService mypageBizService;

    // 2026-07-09 장우철 — 승인 완료 사업자 세션(role=BIZ) 동기화
    // 이유: 관리자 승인 후 재로그인 없이 /mypage/biz ↔ /apply 무한 리다이렉트 방지
    @Autowired
    private MemberAuthService memberAuthService;

    @Autowired
    private FileMapper fileMapper;   
    
    @GetMapping({"", "/"})
    public String biz(HttpSession session) {
        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
        if (memberInfo == null)
            return "redirect:/login";

        // 2026-07-09 장우철 — [변경 후] DB 승인 상태를 세션에 반영 후 업종별 사업자 화면으로 이동
        memberAuthService.enrichSessionWithApprovedBiz(memberInfo);
        session.setAttribute("memberInfo", memberInfo);

        /* [변경 전] 2026-07-09 장우철 — 세션 role 만 확인, APPROVED 인데 USER 이면 /apply 로 루프
        if (!"BIZ".equals(memberInfo.getRole())) {
            return "redirect:/mypage/biz/apply";
        }
        */

        if (!"BIZ".equals(memberInfo.getRole())) {
            return "redirect:/mypage/biz/apply";
        }

        return switch (memberInfo.getBizType()) {
            case "HOSPITAL" -> "redirect:/biz/hospital";
            case "STAY" -> "redirect:/biz/stay";
            case "RESTAURANT" -> "redirect:/biz/restaurant";
            case "GROOMING" -> "redirect:/biz/grooming";
            case "STUDIO" -> "redirect:/biz/studio";
            case "STORE" -> "redirect:/biz/store";
            default -> "mypage/biz";
        };
    }

    /* 사업자 등록 신청 — 폼 페이지 */
    @GetMapping("/apply")
    public String bizApply(HttpSession session,
                            RedirectAttributes redirectAttr) throws Exception {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null)
            return "redirect:/login";

        // 기존 신청 이력 확인
        MypageBizVO apply = mypageBizService.getBizAuthStatus(member.getMemberId());
        if (apply != null) {
        if ("APPROVED".equals(apply.getStatusCd())) {
            // 2026-07-09 장우철 — [변경 후] 승인 완료 시 세션에 BIZ 권한 반영 후 이동
            // 이유: apply.getBizType() 과 로그인 enrich 가 동일한 TB_BUSINESS.BIZ_TYPE 사용
            memberAuthService.enrichSessionWithApprovedBiz(member);
            session.setAttribute("memberInfo", member);
            return "redirect:/mypage/biz";
        }
        // PENDING
        redirectAttr.addFlashAttribute("bizName", apply.getBizName());
        redirectAttr.addFlashAttribute("bizType", apply.getBizType());
        redirectAttr.addFlashAttribute("bizRegNo", apply.getBizRegNo());
        return "redirect:/mypage/biz/complete";
    }

        return "mypage/biz/apply";
    }

    /* 사업자등록번호 확인 — 폼 제출 처리 */
    @PostMapping("/checkBizNo")
    @ResponseBody
    public Map<String, Object> checkBizNo(HttpSession session,
                                          @RequestParam String bizRegNo) throws Exception {

        Map<String, Object> result = new HashMap<>();

        try {
            String baseUrl = "https://api.odcloud.kr/api/nts-businessman/v1/status";
            StringBuilder sb = new StringBuilder(baseUrl);
            sb.append("?serviceKey=").append(URLEncoder.encode(apiService.publicServiceApiKey, "UTF-8"));
            
            String body = "{\"b_no\":[\"" + bizRegNo.replace("-", "") + "\"]}";
            String json = apiService.callApi(sb.toString(), body);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(json);
            JsonNode data = root.path("data");

            if (data.isArray() && data.size() > 0) {
                String status = data.get(0).path("b_stt").asText("");
                // "계속사업자" = 정상 / "휴업자" = 휴업 / "폐업자" = 폐업
                if ("계속사업자".equals(status)) {
                    result.put("success", true);
                    result.put("message", "인증 완료 (계속사업자)");
                } else if (status.isEmpty()) {
                    result.put("success", false);
                    result.put("message", "등록되지 않은 사업자등록번호입니다.");
                } else {
                    result.put("success", false);
                    result.put("message", "사업 상태: " + status);
                }
            } 
            else {
                result.put("success", false);
                result.put("message", "조회 결과가 없습니다.");
            }
        } 
        catch (Exception e) {
            result.put("success", false);
            result.put("message", "API 호출 오류: " + e.getMessage());
        }
        return result;
    }

    /* 사업자 등록 신청 — 폼 제출 처리 */
    @PostMapping("/apply")
    public String bizApplySubmit(@RequestParam(required = true) MultipartFile docFile,
                                 @RequestParam(required = false) MultipartFile licenseFile,
                                 MypageBizVO vo,
                                 RedirectAttributes redirectAttr,
                                 HttpSession session) throws Exception {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null)
            return "redirect:/login";

        vo.setBizId(member.getMemberId());
        vo.setStatusCd("PENDING");

        try {
            // 1) 파일을 디스크에 저장 + FileVO 목록 준비
            //System.currentTimeMillis()
            String subDir = "biz/" + vo.getBizId();
            File dir = new File(webConfig.uploadDir + subDir);
            if (!dir.exists()) 
                dir.mkdirs();

            List<FileVO> fileList = new ArrayList<>();

            if (docFile != null && !docFile.isEmpty()) {
                docFile.transferTo(new File(dir, docFile.getOriginalFilename()));
                FileVO fv = new FileVO();
                fv.setRefType("BIZ_AUTH");
                fv.setFileUrl(subDir + "/" + docFile.getOriginalFilename());
                fv.setDriveFileId("biz_auth" + System.currentTimeMillis());
                fv.setOriginName(docFile.getOriginalFilename());
                fileList.add(fv);
            }

            if (licenseFile != null && !licenseFile.isEmpty()) {
                licenseFile.transferTo(new File(dir, licenseFile.getOriginalFilename()));
                FileVO fv = new FileVO();
                fv.setRefType("BIZ_LICENSE");
                fv.setFileUrl(subDir + "/" + licenseFile.getOriginalFilename());
                fv.setDriveFileId("biz_license" + System.currentTimeMillis());
                fv.setOriginName(licenseFile.getOriginalFilename());
                fileList.add(fv);
            }

            // 2) DB 작업은 Service에서 한 트랜잭션으로 처리
            mypageBizService.applyBusiness(vo, fileList);

            redirectAttr.addFlashAttribute("bizName", vo.getBizName());
            redirectAttr.addFlashAttribute("bizType", vo.getBizType());
            redirectAttr.addFlashAttribute("bizRegNo", vo.getBizRegNo());
            return "redirect:/mypage/biz/complete";
        } 
        catch (Exception e) {
            e.printStackTrace();
            redirectAttr.addFlashAttribute("errorMsg", "신청 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/mypage/biz/apply";
        }
    }

    /* 신청 완료 페이지 */
    @GetMapping("/complete")
    public String bizComplete(HttpSession session) throws Exception {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";

        return "mypage/biz/complete";
    }    
}

/**
 * 역할: 배너 광고 전체 URL 처리
 *
 * - /biz/store/banner**     사업자 배너 신청·목록
 * - /admin/cms/banner**     관리자 배너 승인·반려
 * - /api/banners?position=  사용자 위치별 활성 배너 API
 *
 * 연결
 * - Service: MainBannerService
 * - 사업자 인증: BizBaseController.getBizMember()
 * - 관리자 인증: AdminBaseController.getAdmin()
 */
package com.petcare.petcare.main.banner.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petcare.petcare.main.banner.service.MainBannerService;
import com.petcare.petcare.main.banner.vo.MainBannerVO;

@Controller
public class MainBannerController {

    @Autowired
    private MainBannerService mainBannerService;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  사용자: 위치별 활성 배너 API
    //  예) /api/banners?position=MAIN_HERO
    //      /api/banners?position=STORE
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @GetMapping("/api/banners")
    @ResponseBody
    public List<MainBannerVO> getActiveBanners(@RequestParam(defaultValue = "MAIN_HERO") String position) {
        List<MainBannerVO> result = mainBannerService.getBannersByPosition(position);
        return result;
    }
}

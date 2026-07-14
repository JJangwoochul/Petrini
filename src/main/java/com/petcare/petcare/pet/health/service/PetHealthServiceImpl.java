/**
 * 역할: PetHealthService 구현체
 *
 * 2026/07/14 장우철 — 건강수첩 = TB_MEDICAL_RECORD 회원 조회 + MEMO 태그 파싱
 */

package com.petcare.petcare.pet.health.service;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.hospital.vo.MedicalRecordVO;
import com.petcare.petcare.pet.health.mapper.PetHealthMapper;

@Service
public class PetHealthServiceImpl implements PetHealthService {

    // 사업자 저장 형식: [유형:진료] [체중:28.2kg] ...
    private static final Pattern TAG_TREAT = Pattern.compile("\\[유형:([^\\]]+)\\]");
    private static final Pattern TAG_WEIGHT = Pattern.compile("\\[체중:([^\\]]+?)kg\\]");
    private static final Pattern TAG_TEMP = Pattern.compile("\\[체온:([^\\]]+?)℃\\]");
    private static final Pattern TAG_HR = Pattern.compile("\\[심박:([^\\]]+?)bpm\\]");
    private static final Pattern TAG_BR = Pattern.compile("\\[호흡:([^\\]]+?)회/분\\]");
    private static final Pattern TAG_EXAM = Pattern.compile("\\[검사:([^\\]]+)\\]");
    private static final Pattern TAG_NEXT = Pattern.compile("\\[다음방문:([^\\]]+)\\]");
    private static final Pattern ALL_TAGS = Pattern.compile(
            "\\[(?:유형|체중|체온|심박|호흡|검사|다음방문):[^\\]]*\\]\\s*");

    @Autowired
    private PetHealthMapper petHealthMapper;

    @Override
    @Transactional(readOnly = true)
    public List<MedicalRecordVO> getHealthRecords(Long memberNo, Long petId) throws Exception {
        if (memberNo == null) {
            return List.of();
        }
        List<MedicalRecordVO> list = petHealthMapper.selectMedicalRecordsByMember(memberNo, petId);
        for (MedicalRecordVO r : list) {
            parseRecordMemo(r);
        }
        return list;
    }

    /** MEMO 앞쪽 보조 태그를 VO 필드로 분리하고, 순수 메모만 남김 */
    private void parseRecordMemo(MedicalRecordVO record) {
        String raw = record.getMemo();
        if (raw == null || raw.isBlank()) {
            return;
        }
        record.setTreatType(firstGroup(TAG_TREAT, raw));
        record.setWeight(firstGroup(TAG_WEIGHT, raw));
        record.setTemperature(firstGroup(TAG_TEMP, raw));
        record.setHeartRate(firstGroup(TAG_HR, raw));
        record.setBreathRate(firstGroup(TAG_BR, raw));
        record.setExamItems(firstGroup(TAG_EXAM, raw));
        record.setNextVisit(firstGroup(TAG_NEXT, raw));

        String free = ALL_TAGS.matcher(raw).replaceAll("").trim();
        record.setMemo(free.isEmpty() ? null : free);
    }

    private static String firstGroup(Pattern p, String text) {
        Matcher m = p.matcher(text);
        return m.find() ? m.group(1).trim() : null;
    }
}

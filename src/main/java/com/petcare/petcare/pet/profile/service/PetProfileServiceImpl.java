/**
 * 2026/07/11 장우철 — PetProfileService 구현
 */

package com.petcare.petcare.pet.profile.service;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.petcare.petcare.pet.profile.mapper.PetProfileMapper;
import com.petcare.petcare.pet.profile.vo.PetProfileVO;

@Service
public class PetProfileServiceImpl implements PetProfileService {

    @Autowired
    private PetProfileMapper petProfileMapper;

    @Override
    public List<PetProfileVO> getPetList(Long memberNo) {
        return petProfileMapper.selectPetList(memberNo);
    }

    @Override
    public PetProfileVO getPetDetail(Long petId, Long memberNo) {
        return petProfileMapper.selectPetDetail(petId, memberNo);
    }

    @Override
    @Transactional
    public String savePet(PetProfileVO vo, Long memberNo) {
        String err = validate(vo);
        if (err != null) {
            return err;
        }

        vo.setMemberNo(memberNo);
        vo.setSpecies(mapSpecies(vo.getKind() != null ? vo.getKind() : vo.getSpecies()));
        vo.setAge(calcAge(vo.getBirthDate(), vo.getAge()));

        if (vo.getPetId() == null) {
            int count = petProfileMapper.countPetsByMember(memberNo);
            vo.setIsRepresent(count == 0 ? "Y" : "N");
            petProfileMapper.insertPet(vo);
            return null;
        }

        PetProfileVO existing = petProfileMapper.selectPetDetail(vo.getPetId(), memberNo);
        if (existing == null) {
            return "반려동물을 찾을 수 없습니다.";
        }
        petProfileMapper.updatePet(vo);
        return null;
    }

    @Override
    @Transactional
    public String deletePet(Long petId, Long memberNo) {
        if (petId == null) {
            return "잘못된 요청입니다.";
        }
        PetProfileVO existing = petProfileMapper.selectPetDetail(petId, memberNo);
        if (existing == null) {
            return "반려동물을 찾을 수 없습니다.";
        }
        if (petProfileMapper.countActiveReservationsByPetId(petId) > 0) {
            return "진행 중인 예약(대기/확정)이 있어 삭제할 수 없습니다.";
        }

        boolean wasRepresent = "Y".equalsIgnoreCase(existing.getIsRepresent());
        try {
            int affected;
            // 과거 예약(완료/취소)이 있으면 FK 때문에 물리삭제 불가 → 소프트 삭제
            if (petProfileMapper.countAllReservationsByPetId(petId) > 0) {
                affected = petProfileMapper.softDeletePet(petId, memberNo);
            } else {
                affected = petProfileMapper.deletePet(petId, memberNo);
            }
            if (affected == 0) {
                return "삭제에 실패했습니다. 다시 시도해 주세요.";
            }
            if (wasRepresent) {
                petProfileMapper.promoteFirstRepresent(memberNo);
            }
            return null;
        } catch (DataAccessException e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            return "연결된 데이터가 있어 삭제할 수 없습니다.";
        }
    }

    private String validate(PetProfileVO vo) {
        if (vo.getPetName() == null || vo.getPetName().isBlank()) {
            return "이름을 입력해 주세요.";
        }
        if (vo.getPetName().trim().length() > 30) {
            return "이름은 30자 이내로 입력해 주세요.";
        }
        String kind = vo.getKind() != null ? vo.getKind() : vo.getSpecies();
        if (kind == null || kind.isBlank()) {
            return "종류를 선택해 주세요.";
        }
        if (vo.getBreed() == null || vo.getBreed().isBlank()) {
            return "품종을 선택해 주세요.";
        }
        if (vo.getGender() == null || vo.getGender().isBlank()) {
            return "성별을 선택해 주세요.";
        }
        if (!"M".equals(vo.getGender()) && !"F".equals(vo.getGender())) {
            return "성별 값이 올바르지 않습니다.";
        }
        if (vo.getWeight() != null && (vo.getWeight() < 0 || vo.getWeight() > 200)) {
            return "체중을 확인해 주세요.";
        }
        return null;
    }

    private String mapSpecies(String kind) {
        if (kind == null) {
            return "ETC";
        }
        return switch (kind.trim().toLowerCase()) {
            case "dog" -> "DOG";
            case "cat" -> "CAT";
            default -> "ETC";
        };
    }

    private Integer calcAge(LocalDate birthDate, Integer fallbackAge) {
        if (birthDate != null) {
            int years = Period.between(birthDate, LocalDate.now()).getYears();
            return Math.max(years, 0);
        }
        return fallbackAge;
    }
}

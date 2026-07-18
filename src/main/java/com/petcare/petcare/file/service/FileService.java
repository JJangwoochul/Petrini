package com.petcare.petcare.file.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.file.mapper.FileMapper;
import com.petcare.petcare.file.vo.FileVO;

@Service
public class FileService {
    @Value("${file.upload-dir}")
    public String uploadDir;

    @Autowired
    public FileMapper fileMapper;
    
    @Transactional
    public FileVO uploadFile(MultipartFile file, String refType, Long refId) throws Exception {

        // 1) 저장 폴더: uploadDir/hospital/3/
        String subDir = refType.toLowerCase() + "/" + refId;
        File dir = new File(uploadDir + subDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 2) 파일명 중복 방지: UUID + 원본 확장자
        String originName = file.getOriginalFilename();
        String ext = "";
        if (originName != null && originName.contains(".")) {
            ext = originName.substring(originName.lastIndexOf("."));
        }
        String savedName = UUID.randomUUID().toString() + ext;

        // 3) 디스크에 저장
        File dest = new File(dir, savedName);
        file.transferTo(dest);

        // 4) DB INSERT (selectKey로 fileId가 VO에 자동 세팅됨)
        FileVO vo = new FileVO();
        vo.setRefType(refType);
        vo.setRefId(refId);
        vo.setFileUrl(subDir + "/" + savedName);
        vo.setOriginName(originName);
        fileMapper.insertFile(vo);

        return vo;
    }
    
    @Transactional
    public void deleteFile(Long fileId) throws Exception {

        // 1) DB에서 경로 조회
        FileVO file = fileMapper.selectFile(fileId);
        if (file == null) {
            return;
        }

        // 2) 디스크 파일 삭제
        File diskFile = new File(uploadDir + file.getFileUrl());
        if (diskFile.exists()) {
            diskFile.delete();
        }

        // 3) DB 삭제
        fileMapper.deleteFile(fileId);
    }

public List<FileVO> getFileList(String refType, Long refId) throws Exception {
        FileVO param = new FileVO();
        param.setRefType(refType);
        param.setRefId(refId);
        param.setDriveFileId(refType.toLowerCase() + "_" + System.currentTimeMillis());
        return fileMapper.selectFileList(param);
    }

    //지윤 26.07.15 추가: 상품 이미지 교체 시 기존 파일들(디스크+DB) 전부 삭제 - 새 이미지 올리기 전에 호출
    @Transactional
    public void deleteFilesByRef(String refType, Long refId) throws Exception {
        List<FileVO> files = getFileList(refType, refId);
        for (FileVO f : files) {
            deleteFile(f.getFileId());
        }
    }
}

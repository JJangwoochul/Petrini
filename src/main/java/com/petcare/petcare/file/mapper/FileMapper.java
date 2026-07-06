package com.petcare.petcare.file.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.petcare.petcare.file.vo.FileVO;

@Mapper
public interface FileMapper {
    int insertFile(FileVO vo) throws Exception;
    List<FileVO> selectFileList(FileVO vo) throws Exception;  // refType + refId로 조회
    int deleteFilesByRefId(FileVO vo) throws Exception; 
}

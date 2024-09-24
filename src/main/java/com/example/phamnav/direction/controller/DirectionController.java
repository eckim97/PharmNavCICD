package com.example.phamnav.direction.controller;

import com.example.phamnav.direction.service.DirectionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
@Slf4j
@RequiredArgsConstructor
public class DirectionController {
    private final DirectionService directionService;
    private static final String DIRECTION_BASE_URL = "https://map.kakao.com/link/map/";

    @GetMapping("/dir/{encodedId}")
    public String searchDirection(@PathVariable("encodedId") String encodedId) {
        directionService.findDirectionUrlById(encodedId);

        String result = directionService.findDirectionUrlById(encodedId);

        log.info("[DirectionController searchDirection] direction url: {}", result);

        return "redirect:" +result;
    }

}

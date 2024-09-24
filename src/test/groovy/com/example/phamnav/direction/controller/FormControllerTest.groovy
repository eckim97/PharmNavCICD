package com.example.phamnav.direction.controller

import com.example.phamnav.dto.OutputDto
import com.example.phamnav.pharmacy.service.PharmacyRecommendationService
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.setup.MockMvcBuilders
import spock.lang.Specification

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*

class FormControllerTest extends Specification {

    private MockMvc mockMvc
    private PharmacyRecommendationService pharmacyRecommendationService = Mock()
    private List<OutputDto> outputDtoList

    def setup() {
        // FormController MockMvc 객체로 만든다.
        mockMvc = MockMvcBuilders.standaloneSetup(new FormController(pharmacyRecommendationService))
                .build()

        outputDtoList = new ArrayList<>()
        outputDtoList.addAll(
                OutputDto.builder()
                        .pharmacyName("pharmacy1")
                        .build(),
                OutputDto.builder()
                        .pharmacyName("pharmacy2")
                        .build()
        )
    }

    def "GET /"() {
        expect:
        // FormController 의 "/" URI를 get 방식으로 호출
        mockMvc.perform(get("/"))
                .andExpect(handler().handlerType(FormController.class))
                .andExpect(handler().methodName("main"))
                .andExpect(status().isOk())
                .andExpect(view().name("main"))
                .andDo(log())

    }

    def "POST /search"() {
        given:
        String inputAddress = "서울 성북구 종암동"

        when:
        def resultActions = mockMvc.perform(post("/search")
                .param("address", inputAddress))

        then:
        1 * pharmacyRecommendationService.recommendPharmacyList(argument -> {
            assert argument == inputAddress
        }) >> outputDtoList

        resultActions
                .andExpect(status().isOk())
                .andExpect(view().name("output"))
                .andExpect(model().attributeExists("outputFormList"))
                .andExpect(model().attribute("outputFormList", outputDtoList))
                .andDo(print())

    }
}
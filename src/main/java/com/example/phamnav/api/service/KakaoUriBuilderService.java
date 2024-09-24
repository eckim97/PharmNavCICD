package com.example.phamnav.api.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;

@Slf4j
@Service
public class KakaoUriBuilderService {
    private static final String KAKAO_LOCAL_SEARCH_ADDRESS_URL = "https://dapi.kakao.com/v2/local/search/address.json";

    private static final String KAKAO_LOCAL_CATEGORY_SEARCH_URL = "https://dapi.kakao.com/v2/local/search/address.json";

    public URI buildUriByAddressSearch(String address) {
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(KAKAO_LOCAL_SEARCH_ADDRESS_URL);
        uriBuilder.queryParam("query", address);

        URI uri = uriBuilder.build().encode().toUri();
        log.info("[KakaoUriBuilderService buildUriByAddressSearch] address: {}, uri : {}", address, uri);

        return uri;
    }

    public URI buildUriByCategorySearch(double latitude, double longitude, double radius, String category) {

        double meterRadius = radius * 1000;

        UriComponentsBuilder uriBUilder = UriComponentsBuilder.fromHttpUrl(KAKAO_LOCAL_CATEGORY_SEARCH_URL);
        uriBUilder.queryParam("category_group_code", category);
        uriBUilder.queryParam("x", longitude);
        uriBUilder.queryParam("y", latitude);
        uriBUilder.queryParam("radius", meterRadius);
        uriBUilder.queryParam("sort", "distance");

        URI uri = uriBUilder.build().encode().toUri();

        log.info("[KakaoAddressSearchService buildUriByCategorySearch] uri: {} ", uri);

        return uri;
    }
}

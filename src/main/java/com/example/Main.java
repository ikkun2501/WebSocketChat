package com.example;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.reactive.HandlerMapping;
import org.springframework.web.reactive.config.EnableWebFlux;
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.server.support.WebSocketHandlerAdapter;
import reactor.core.publisher.EmitterProcessor;

@SpringBootApplication
@EnableWebFlux
public class Main {

    public static void main(String[] args) {
        SpringApplication.run(Main.class, args);
    }

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Bean
    public WebSocketHandlerAdapter handlerAdapter() {
        return new WebSocketHandlerAdapter();
    }


    @Bean
    public HandlerMapping handlerMapping() {

        EmitterProcessor<String> processor = EmitterProcessor.create();

        Map<String, WebSocketHandler> mappings = new HashMap<>(2);
        mappings.put("/chat", new ChatWebSocketHandler(processor));

        SimpleUrlHandlerMapping mapping = new SimpleUrlHandlerMapping();
        mapping.setUrlMap(mappings);
        mapping.setOrder(10);

        return mapping;
    }


}

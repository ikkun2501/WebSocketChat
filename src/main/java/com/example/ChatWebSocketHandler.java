package com.example;

import org.reactivestreams.Publisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import org.yaml.snakeyaml.emitter.Emitter;
import reactor.core.publisher.EmitterProcessor;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class ChatWebSocketHandler implements WebSocketHandler {

    private final Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler.class);

    private final EmitterProcessor<String> processor;

    public ChatWebSocketHandler(EmitterProcessor<String> processor) {
        this.processor = processor;
    }

    public Mono<Void> handle(WebSocketSession session) {

        session.receive()
                .map(WebSocketMessage::getPayloadAsText)
                .log()
                .subscribe(processor::onNext);

        return session.send(processor.map(session::textMessage));
    }

}
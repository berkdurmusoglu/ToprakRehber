package com.project.ToprakRehberi;

import com.project.ToprakRehberi.utilities.exceptions.*;
import org.modelmapper.ModelMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.orm.jpa.JpaObjectRetrievalFailureException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;

@RestControllerAdvice
@SpringBootApplication
public class ToprakRehberiApplication {

    public static void main(String[] args) {
        SpringApplication.run(ToprakRehberiApplication.class, args);
    }

    @Bean
    public ModelMapper getModelMapper() {
        return new ModelMapper();
    }

    /*@ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ProblemDetails handleAuthException(AuthException authException) {
        ProblemDetails problemDetails = new ProblemDetails();
        problemDetails.setMessage(authException.getMessage());
        return problemDetails;
    }*/
    @ExceptionHandler(AuthException.class)
    public ResponseEntity<Object> handleAuthException(AuthException ex) {
        Map<String, String> response = new HashMap<>();
        response.put("error", ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public ProblemDetails handleLandException(LandException landException) {
        ProblemDetails problemDetails = new ProblemDetails();
        problemDetails.setMessage(landException.getMessage());
        return problemDetails;
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ProblemDetails handleJpaObjectException(NoSuchElementException noSuchElementException) {
        ProblemDetails problemDetails = new ProblemDetails();
        problemDetails.setMessage(noSuchElementException.getMessage());
        ;
        return problemDetails;
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ProblemDetails handleMethodArgumentException(MethodArgumentNotValidException methodArgumentNotValidException) {
        ValidationProblemDetails validationProblemDetails = new ValidationProblemDetails();
        validationProblemDetails.setMessage("VALIDATION EXCEPTION");
        validationProblemDetails.setValidationErrors(new HashMap<String, String>());
        for (FieldError fieldError : methodArgumentNotValidException.getBindingResult().getFieldErrors()) {
            validationProblemDetails.getValidationErrors().put(fieldError.getField(), fieldError.getDefaultMessage());
        }
        return validationProblemDetails;
    }
    @ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ProblemDetails JpaObject(JpaObjectException jpaObjectException) {
        ProblemDetails problemDetails = new ProblemDetails();
        problemDetails.setMessage(jpaObjectException.getMessage());
        return problemDetails;
    }
    @ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ProblemDetails DuplicateException(DuplicateException duplicateException) {
        ProblemDetails problemDetails = new ProblemDetails();
        problemDetails.setMessage(duplicateException.getMessage());
        return problemDetails;
    }



}

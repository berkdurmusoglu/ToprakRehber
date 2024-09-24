package com.project.ToprakRehberi.repository;

import com.project.ToprakRehberi.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findById(int id);
    User findByMail(String mail);

    User findByMailAndTelNoAndPassword(String mail,String password,String telNo);

    List<User> findByState(String state);

    Boolean existsByMailAndPassword(String mail, String password);

    User findByMailAndPassword(String mail, String password);

    Boolean existsByTelNo(String telNo);

    Boolean existsByMail(String mail);


}

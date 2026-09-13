package com.fitbizz.repository;

import com.fitbizz.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByTenantIdAndEmail(String tenantId, String email);
    Optional<User> findByEmail(String email);
}

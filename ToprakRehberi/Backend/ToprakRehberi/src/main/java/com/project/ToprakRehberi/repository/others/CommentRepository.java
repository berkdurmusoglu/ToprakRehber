package com.project.ToprakRehberi.repository.others;

import com.project.ToprakRehberi.entities.other.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    @Query("select c from Comment  c where c.user.id  = :userID")
    List<Comment> getAllCommentsByUserID(int userID);

    @Query("select c from Comment  c where c.rehber.id  = :rehberID")
    List<Comment> getAllCommentsByRehberID(int rehberID);

    @Query("select c from Comment  c where c.hasat.id  = :HasatID")
    List<Comment> getAllCommentsByHasatID(int HasatID);

    @Query("SELECT c FROM Comment c WHERE c.hasat IN (" +
            "SELECT h FROM Hasat h WHERE h.ekim IN (" +
            "SELECT e FROM Ekim e WHERE e.land.mahalle IN (" +
            "SELECT l.mahalle FROM Land l WHERE l.user.id = :userID)))")
    List<Comment> getAllComment(int userID);



}

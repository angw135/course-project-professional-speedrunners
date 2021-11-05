package com.boba.bobabuddy.infrastructure.controller;

import com.boba.bobabuddy.core.entity.User;
import com.boba.bobabuddy.core.usecase.exceptions.DifferentResourceException;
import com.boba.bobabuddy.core.usecase.exceptions.DuplicateResourceException;
import com.boba.bobabuddy.core.usecase.exceptions.ResourceNotFoundException;
import com.boba.bobabuddy.core.usecase.port.request.CreateUserRequest;
import com.boba.bobabuddy.core.usecase.port.userport.*;
import com.boba.bobabuddy.infrastructure.assembler.UserResourceAssembler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

@RestController
public class UserController {

    private final ICreateUser createUser;
    private final IFindUser findUser;
    private final IRemoveUser removeUser;
    private final IUpdateUser updateUser;
    private final UserResourceAssembler assembler;

    @Autowired
    public UserController(ICreateUser createUser, IFindUser findUser, ILoginUser loginUser, IRemoveUser removeUser, IUpdateUser updateUser, UserResourceAssembler assembler) {
        this.createUser = createUser;
        this.findUser = findUser;
        this.removeUser = removeUser;
        this.updateUser = updateUser;
        this.assembler = assembler;
        this.assembler.setBasePath("/api");
    }

    @PostMapping(path = "/api/users")
    public ResponseEntity<EntityModel<User>> createUser(@RequestBody CreateUserRequest createUserRequest) {
        try {
            return ResponseEntity.ok(assembler.toModel(createUser.create(createUserRequest.createUser())));
        } catch (DuplicateResourceException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage(), e);
        }
    }

    @GetMapping(path = "/api/users/{email}")
    public ResponseEntity<EntityModel<User>> findByEmail(@PathVariable String email) {
        try {
            return ResponseEntity.ok(assembler.toModel(findUser.findByEmail(email)));
        } catch (ResourceNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage(), e);
        }
    }

    @GetMapping(path = "/api/users", params = "name")
    public ResponseEntity<CollectionModel<EntityModel<User>>> findByName(@RequestParam("name") String name) {
        return ResponseEntity.ok(assembler.toCollectionModel(findUser.findByName(name)));
    }

    @GetMapping(path = "/api/users")
    public ResponseEntity<CollectionModel<EntityModel<User>>> findAll() {
        return ResponseEntity.ok(assembler.toCollectionModel(findUser.findAll()));
    }

    @DeleteMapping(path = "/api/users/{email}")
    public ResponseEntity<EntityModel<User>> removeUserByEmail(@PathVariable String email) {
        try {
            return ResponseEntity.ok(assembler.toModel(removeUser.removeByEmail(email)));
        } catch (ResourceNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage(), e);
        }
    }

    @PutMapping(path = "/api/users/{email}")
    public ResponseEntity<EntityModel<User>> updateUser(@PathVariable String email, @RequestBody User userPatch){
        try {
            return ResponseEntity.ok(assembler.toModel(updateUser.updateUser(findUser.findByEmail(email), userPatch)));
        } catch (ResourceNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage(), e);
        } catch (DifferentResourceException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage(), e);
        }
    }

//    public ResponseEntity<EntityModel<User>> findByRating(UUID id) {
//       try {
//           return ResponseEntity.ok(assembler.toModel(findUser.findByRating(id)));
//       } catch (ResourceNotFoundException e){
//           throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage(), e);
//       }
//    }

//    @GetMapping(path = "/api/user/{email}")
//    public boolean loginUser(@RequestBody LoginUserRequest loginUserRequest, @PathVariable String email) throws ResourceNotFoundException {
//        User user = findUser.findByEmail(email);
//        return loginUser.logIn(user, loginUserRequest.getPassword());
//    }
}

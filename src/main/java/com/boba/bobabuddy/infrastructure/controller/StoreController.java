package com.boba.bobabuddy.infrastructure.controller;

import com.boba.bobabuddy.core.entity.Store;
import com.boba.bobabuddy.core.usecase.exceptions.DifferentResourceException;
import com.boba.bobabuddy.core.usecase.exceptions.ResourceNotFoundException;
import com.boba.bobabuddy.core.usecase.port.request.CreateStoreRequest;
import com.boba.bobabuddy.core.usecase.port.storeport.ICreateStore;
import com.boba.bobabuddy.core.usecase.port.storeport.IFindStore;
import com.boba.bobabuddy.core.usecase.port.storeport.IRemoveStore;
import com.boba.bobabuddy.core.usecase.port.storeport.IUpdateStore;
import com.boba.bobabuddy.core.usecase.store.exceptions.NoSuchStoreException;
import com.boba.bobabuddy.core.usecase.store.exceptions.StoreNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/***
 * REST controller for Store related api calls
 * Note that the current structure and behaviour of these api definitions are not necessarily RESTful. At this moment
 * in time it only server as an example of roughly how an API controller should be set up.
 */

@RestController
public class StoreController {

    //fields for all Store usecase, with interface
    private final ICreateStore createStore;
    private final IRemoveStore removeStore;
    private final IUpdateStore updateStore;
    private final IFindStore findStore;

    @Autowired
    public StoreController(ICreateStore createStore, IRemoveStore removeStore, IUpdateStore updateStore,
                           IFindStore findStore) {
        this.createStore = createStore;
        this.findStore = findStore;
        this.removeStore = removeStore;
        this.updateStore = updateStore;
    }

    /***
     * add the Store resource into the database.
     * @param createStoreRequest Request class that contains data necessary to construct a Store entity.
     * @return Store that was constructed, which will be automatically converted to JSON and send it to the caller.
     */
    // Simply, a POST request called to the endpoint <domain address>/api/store/ will be mapped to this method.
    // the <produces> parameter decides how the return value will be converted to and be sent back to the caller,
    // in this case a JSON.
    // the @RequestBody annotation indicates that the body of an HTTP request will be interpreted as an POJO
    // representation by HTTPMessageConverter, which converts it to the parameter type (in this case createStoreRequest).
    // Then, it will be passed to the method.
    @PostMapping(path = "/api/store/", produces = MediaType.APPLICATION_JSON_VALUE)
    public Store createStore(@RequestBody CreateStoreRequest createStoreRequest) {
        return createStore.create(createStoreRequest.toStore());
    }

    /***
     * Query for all exiting store resource
     * @return list of store resources exist in the database
     */
    @GetMapping(path = "/api/store/")
    public List<Store> findAll() {
        return findStore.findAll();
    }

    /***
     * query for store resources that have matching location.
     * @param location location of required store
     * @return A store resource that match the query.
     */
    @GetMapping(path = "/api/store/", params = "location")
    public List<Store> findByLocation(@RequestParam("location") String location) {
        return findStore.findByLocation(location);
    }

    /***
     * query for a store resource with matching id.
     * @param id the primary uuid key of the resource
     * @return Store with matching UUID, which will be automatically converted to JSON and send it to the caller.
     * @throws StoreNotFoundException thrown when the store was not found
     */
    // Exceptions thrown in controller class will be handled automatically by SpringFramework
    @GetMapping(path = "/api/store/{id}")
    public Store findById(@PathVariable UUID id) throws ResourceNotFoundException {
        return findStore.findById(id);
    }

    /***
     * query for store resources that have matching name.
     * @param name name of required store
     * @return A store resource that match the query.
     */
    @GetMapping(path = "/api/store/", params = "name")
    public List<Store> findByName(@RequestParam("name") String name) {
        return findStore.findByName(name);
    }

    /***
     * query for store resource that partially matches the provided name
     * @param nameContain infix of required store's name
     * @return list of store resources that match the query.
     */
    @GetMapping(path = "/api/store/", params = "name-contain")
    public List<Store> findByNameContaining(@RequestParam("name-contain") String nameContain) {
        return findStore.findByNameContaining(nameContain);
    }

    /***
     * query for store resources that have rating greater than or equal to a given value
     * @param rating the rating used for comparison
     * @param sorted whether returned list should be sorted
     * @return list of store resources that match the query.
     */
    @GetMapping(path = "/api/store/", params = "rating-geq")
    public List<Store> findByAvgRatingGreaterThanEqual(@RequestParam("rating-geq") float rating,
                                                       @RequestParam(defaultValue = "false") boolean sorted) {
        return findStore.findByAvgRatingGreaterThanEqual(rating, sorted);
    }

    /***
     * Update a store given its id by overwriting it.
     * @param id the primary uuid key of the resource
     * @return updated store
     * @throws NoSuchStoreException thrown when the store (found via param id) does not exist in the database.
     * @throws StoreNotFoundException thrown when store was not found
     */
    @PutMapping(path = "/api/store/{id}")
    public Store updateStore(@RequestParam Store storePatch, @PathVariable UUID id) throws ResourceNotFoundException,
            DifferentResourceException {
        return updateStore.updateStore(findById(id), storePatch);
    }

    /***
     * Removes a store from database that has the matching storeId.
     * @param id the primary uuid key of the resource
     * @return Store that was removed from the database.
     * @throws StoreNotFoundException thrown when store was not found
     */
    @DeleteMapping(path = "/api/store/{id}")
    public Store removeStore(@PathVariable UUID id) throws ResourceNotFoundException {
        return removeStore.removeById(id);
    }


}

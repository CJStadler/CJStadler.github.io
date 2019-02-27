SRC_DIR := todo-app
BUILD_DIR := todo

.PHONY: update clean

update:
	git -C $(SRC_DIR) pull # Update todo-app
	$(MAKE) optimize -C $(SRC_DIR) # Build todo-app
	$(MAKE) todo # Copy output into todo/

todo: $(wildcard $(SRC_DIR)/*)
	cp -rfvT $(SRC_DIR)/site todo

clean:
	rm -rf $(BUILD_DIR)

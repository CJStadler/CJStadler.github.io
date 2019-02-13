SRC_DIR := todo-app
BUILD_DIR := todo

.PHONY: update clean

update:
	git -C $(SRC_DIR) pull
	$(MAKE) -C $(SRC_DIR)
	$(MAKE) todo

todo: $(wildcard $(SRC_DIR)/*)
	cp -rfvT $(SRC_DIR)/site todo

clean:
	rm -rf $(BUILD_DIR)

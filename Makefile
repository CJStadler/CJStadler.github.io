TODO_SRC := todo-app
TODO_BUILD := todo

LAP_COUNTER_SRC := lap-counter-repo
LAP_COUNTER_BUILD := lap-counter

HN_SRC := hn-repo
HN_BUILD := hn

.PHONY: update-all clean

update-all:
	$(MAKE) $(TODO_BUILD)
	$(MAKE) $(LAP_COUNTER_BUILD)
	$(MAKE) $(HN_BUILD)

$(TODO_BUILD): $(wildcard $(TODO_SRC)/*)
	git -C $(TODO_SRC) pull # Update todo-app
	$(MAKE) optimize -C $(TODO_SRC) # Build todo-app
	cp -rfvT $(TODO_SRC)/site $(TODO_BUILD) # Copy output into todo/

$(LAP_COUNTER_BUILD): $(wildcard $(LAP_COUNTER_REPO)/*)
	git -C $(LAP_COUNTER_SRC) pull # Update
	cd $(LAP_COUNTER_SRC); $(MAKE) optimized # Have to use cd or else webpack isn't found.
	cp -rfvT $(LAP_COUNTER_SRC)/dist $(LAP_COUNTER_BUILD) # Copy into lap-counter/

$(HN_BUILD): $(wildcard $(HN_REPO)/*)
	git -C $(HN_SRC) pull # Update
	cd $(HN_SRC); $(MAKE) # Have to use cd or else webpack isn't found.
	cp -rfvT $(HN_SRC)/dist $(HN_BUILD) # Copy into lap-counter/

clean:
	rm -rf $(TODO_BUILD) $(LAP_COUNTER_BUILD) $(HN_BUILD)

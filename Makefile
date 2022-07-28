LAP_COUNTER_SRC := lap-counter-repo
LAP_COUNTER_BUILD := lap-counter

.PHONY: update-all clean

update-all:
	$(MAKE) lap-counter

$(LAP_COUNTER_BUILD): $(wildcard $(LAP_COUNTER_REPO)/*)
	git -C $(LAP_COUNTER_SRC) pull # Update
	cd $(LAP_COUNTER_SRC); $(MAKE) optimized  # Have to use cd or else webpack isn't found.
	cp -rfvT $(LAP_COUNTER_SRC)/dist $(LAP_COUNTER_BUILD) # Copy into lap-counter/

clean:
	rm -rf $(LAP_COUNTER_BUILD)

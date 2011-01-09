LDFLAGS += -lm

c/bin/%: c/%.c
	${CC} ${CFLAGS} ${LDFLAGS} $< -o $@

c%: c/bin/%
	time $<

e%: erlang/p%.erl
	mkdir -p tmp
	sh -c 'cd tmp; erlc ../$<; echo ""; \
	time erl -noshell -shutdown_time 1 -s `basename $< .erl` main "" -s init stop'

stats:
	bin/stats

clean:
	rm -f c/bin/* tmp/*.beam

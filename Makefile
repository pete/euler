LDFLAGS += -lm

c/bin/%: c/%.c
	${CC} ${CFLAGS} ${LDFLAGS} $< -o $@

c%: c/bin/%
	time $<

pure/bin/%: pure/%.pure
	pure -c $< -o $@

p%: pure/bin/%
	time $<

e%: erlang/p%.erl
	mkdir -p tmp
	sh -c 'cd tmp; erlc ../$<; echo ""; \
	time erl -noshell -shutdown_time 1 -s `basename $< .erl` main "" -s init stop'

a%: awk/%.awk
	time awk -f $<

a102: awk/102.awk
	time awk -F, -f awk/102.awk data/102.txt

stats:
	bin/stats

clean:
	rm -f c/bin/* tmp/*.beam

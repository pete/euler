LDFLAGS += -lm

c/bin/%: c/%.c
	${CC} ${CFLAGS} ${LDFLAGS} $< -o $@

c%: c/bin/%
	time $<

e%: erlang/p%.erl
	time escript $<

stats:
	bin/stats

clean:
	rm -f c/bin/*

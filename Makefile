LDFLAGS += -lm

# General stuff

stats:
	bin/stats

clean:
	rm -f pure/bin/* c/bin/* tmp/*.beam

# awk
a%: awk/%.awk
	time awk -f $<

a099: awk/099.awk
	time awk -F, -f awk/099.awk data/099.txt

a102: awk/102.awk
	time awk -F, -f awk/102.awk data/102.txt

# C
c%: c/bin/%
	time $<

c/bin/%: c/%.c
	${CC} ${CFLAGS} ${LDFLAGS} $< -o $@

# Erlang
e%: erlang/p%.erl
	mkdir -p tmp
	sh -c 'cd tmp; erlc ../$<; echo ""; \
	time erl -noshell -shutdown_time 1 -s `basename $< .erl` main "" -s init stop'

# Limbo
INFERNO_ROOT = $(HOME)/proj/inferno-os
INFERNO_HOME = $(INFERNO_ROOT)/usr/$(USER)
EMU_FLAGS += -c1
EMU_FLAGS += -r $(INFERNO_ROOT)
i%: $(INFERNO_HOME)/i%.dis
	time emu $(EMU_FLAGS) /usr/$(USER)/$@

LIMBO_FLAGS += -w
LIMBO_FLAGS += -g
$(INFERNO_HOME)/i%.dis: limbo/l%.b
	limbo $(LIMBO_FLAGS) -o $@ $<


# Pure
p%: pure/bin/%
	time $<

pure/bin/%: pure/%.pure
	pure -g -c $< -o $@

# Racket
r%: racket/bin/%
	time $<

racket/bin/%: racket/%.rkt
	raco exe -o $@ $<

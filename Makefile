LDFLAGS += -lm
CFLAGS += -std=c99

# General stuff

stats:
	bin/stats

clean:
	rm -f pure/bin/* c/bin/* tmp/*.beam go/bin/* limbo/*.dis limbo/*.sbl

# awk
a%: awk/%.awk
	time awk -f $<

a067: awk/067.awk
	time awk -f awk/067.awk data/067.txt
a099: awk/099.awk
	time awk -F, -f awk/099.awk data/099.txt
a102: awk/102.awk
	time awk -F, -f awk/102.awk data/102.txt

# C
c%: c/bin/%
	time $<

c/bin/%: c/%.c
	${CC} ${CFLAGS} ${LDFLAGS} $< -o $@

# Go
g%: go/bin/%
	time $<

go/bin/%: go/%.go
	go build -o $@ $<

# Erlang
e%: erlang/p%.erl
	mkdir -p tmp
	sh -c 'cd tmp; erlc ../$<; echo ""; \
	time erl -noshell -shutdown_time 1 -s `basename $< .erl` main "" -s init stop'

# Limbo
INFERNO_ROOT = $(HOME)/inferno
INFERNO_HOME = $(INFERNO_ROOT)/usr/$(USER)/euler
EMU_FLAGS += -c1
EMU_FLAGS += -r $(INFERNO_ROOT)
EMU_FLAGS += -pmain=1073741824 -pheap=1073741824
LIMBO_FLAGS += -w
LIMBO_FLAGS += -g
l%: limbo/l%.b
	mkdir -p $(INFERNO_HOME)
	limbo $(LIMBO_FLAGS) -o $(INFERNO_HOME)/$@ $<
	time emu $(EMU_FLAGS) /usr/$(USER)/euler/$@

# The Inferno sh(1)
i%: infernosh/%.sh
	mkdir -p $(INFERNO_HOME)
	cp $< $(INFERNO_HOME)/$@.sh
	time emu $(EMU_FLAGS) sh /usr/$(USER)/euler/$@.sh

i067: infernosh/067.sh
	mkdir -p $(INFERNO_HOME)
	cp $< $(INFERNO_HOME)/067.sh
	cp data/067.txt $(INFERNO_HOME)
	time emu $(EMU_FLAGS) sh -n -c '/usr/$(USER)/euler/067.sh < /usr/$(USER)/euler/067.txt'
i079: infernosh/079.sh
	mkdir -p $(INFERNO_HOME)
	cp $< $(INFERNO_HOME)/079.sh
	cp data/079.txt $(INFERNO_HOME)
	time emu $(EMU_FLAGS) sh -n -c '/usr/$(USER)/euler/079.sh < /usr/$(USER)/euler/079.txt'

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

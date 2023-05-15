# Compiler
PROLOG = swipl

# Directories
SRC_DIR = src
OUT_DIR = .

# Files
SRC_FILE = $(SRC_DIR)/main.pl
OUT_FILE = $(OUT_DIR)/flp22-log

all: $(OUT_FILE)

$(OUT_FILE): $(SRC_FILE)
	$(PROLOG) --stack_limit=16g -q -g start -o $(OUT_FILE) -c $(SRC_FILE) || $(PROLOG) -G16g -L16g -q -g start -o $(OUT_FILE) -c $(SRC_FILE)

clean:
	rm -f $(OUT_FILE)
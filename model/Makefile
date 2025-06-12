# File: Makefile

# Compiler and flags
CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++11

# Target executable name
TARGET := golden_gen

# Source files
SRC := golden_val.cpp

# Default rule
all: $(TARGET)

# Linking rule
$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

# Run the executable
run: $(TARGET)
	./$(TARGET)

# Clean generated files
clean:
	rm -f $(TARGET)

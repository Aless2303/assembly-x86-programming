# x86 Assembly Programming Collection

A comprehensive collection of x86 Assembly programs demonstrating low-level programming concepts, algorithms, and system interactions. This repository showcases practical implementations of fundamental computer science concepts using 32-bit x86 Assembly language.

## 🎯 Overview

This repository contains educational and practical Assembly programs that demonstrate proficiency in:
- Low-level system programming
- Memory management and data structures
- File I/O operations
- Algorithm implementation
- Security concepts and buffer protection
- Floating-point arithmetic
- SIMD operations

## 📁 Project Structure

### Core Programming Concepts

#### **String and Character Manipulation**
- **`InversareNumePrenume_EB.asm`** - String reversal and name formatting
- **`p1.asm`** - XOR encryption/decryption implementation
- **`problemaChecker.asm`** - Complex string encryption with hexadecimal output

#### **Mathematical Operations**
- **`cmmdc_EW.asm`** - Greatest Common Divisor (Euclidean algorithm)
- **`p5.asm`** - Power calculation using iterative multiplication
- **`p6.asm`** - GCD calculation with function parameters
- **`pa.asm`** - Advanced floating-point polynomial evaluation using FPU

#### **Data Structures and Algorithms**

**Array and Vector Operations:**
- **`p3.asm`** - Array summation with stack-based number display
- **`sumVect_EB.asm`** - Vector summation from file input
- **`citireVectNeg_EB.asm`** - Handling negative numbers in vectors
- **`sortareVector_EW.asm`** - Bubble sort implementation for vectors

**Matrix Operations:**
- **`p2.asm`** - Matrix transposition (4x4)
- **`p4.asm`** - Column summation in matrices
- **`matriceTranspusaAfisare_EB.asm`** - Matrix transposition with file output

#### **Advanced Algorithms**
- **`pj.asm`** - Complete sorting program with ASCII-to-binary conversion
- **`pf.asm` & `pg.asm`** - Advanced vector sorting with file I/O

### System Programming

#### **File I/O Operations**
- **`pb.asm`** - Basic file creation, writing, and reading
- **`pc.asm` & `pe.asm`** - Advanced file handling with stat system calls
- **`ph.asm`** - Matrix file processing with custom functions library

#### **SIMD and Parallel Processing**
- **`pd.asm`** - SSE vector addition using packed single-precision operations

#### **Security Concepts**
- **`p8.asm`** - Stack canary implementation for buffer overflow protection
- **`p9.asm`** - Hardware random number generation for security

### Utility Libraries and Functions

#### **`functions.asm`** - Comprehensive Function Library
A robust library containing:
- **String Operations**: Length calculation, printing, reading, ASCII conversion
- **File Management**: Open, read, write, create, close operations
- **Mathematical Functions**: Power calculations, comparisons
- **Character Handling**: Number conversion, hexadecimal output
- **Memory Management**: Stack manipulation utilities

#### **Conversion Utilities**
- **`ascbin_IB.asm`** - ASCII to binary conversion
- **`binasc_IB.asm`** - Binary to ASCII conversion
- **`hexDump_IB.asm`** - Memory dumping in hexadecimal format

### Interactive Applications
- **`P0.asm`** - Complete Tic-Tac-Toe game with user interaction

## 🛠 Technical Skills Demonstrated

### **Low-Level Programming**
- **Register Management**: Efficient use of EAX, EBX, ECX, EDX, ESI, EDI
- **Stack Operations**: Push/pop operations, stack frame management
- **Memory Addressing**: Direct, indirect, and indexed addressing modes

### **System Calls and OS Interaction**
- File operations (sys_open, sys_read, sys_write, sys_close, sys_stat)
- Memory management and cursor positioning
- Standard I/O handling

### **Data Type Handling**
- **Integers**: 8-bit (db), 16-bit (dw), 32-bit (dd) operations
- **Floating-Point**: FPU operations for mathematical calculations
- **Strings**: Character arrays and null-terminated strings
- **Arrays and Matrices**: Multi-dimensional data structure manipulation

### **Algorithm Implementation**
- **Sorting Algorithms**: Bubble sort for various data types
- **Mathematical Algorithms**: GCD, power calculation, polynomial evaluation
- **Conversion Algorithms**: Base conversion, ASCII/binary transformation

### **Advanced Concepts**
- **SIMD Programming**: SSE instructions for parallel processing
- **Security Programming**: Buffer overflow protection, canary values
- **Hardware Interaction**: Random number generation, FPU utilization

## 🔧 Key Features

### **File Processing Pipeline**
Most programs follow a structured approach:
1. **Input Processing**: Read from files or user input
2. **Data Conversion**: ASCII to binary transformation
3. **Algorithm Execution**: Core logic implementation
4. **Output Generation**: Results written to files or console

### **Error Handling and Validation**
- Input validation for user interactions
- Buffer overflow protection mechanisms
- Proper file descriptor management

### **Modular Programming**
- Reusable function libraries
- Consistent coding patterns
- Well-structured program organization

## 📚 Learning Outcomes

This collection demonstrates proficiency in:

1. **System-Level Programming**: Understanding of how high-level concepts translate to machine code
2. **Memory Management**: Direct memory manipulation and efficient resource usage
3. **Algorithm Design**: Implementation of fundamental computer science algorithms
4. **I/O Operations**: Comprehensive file and stream handling
5. **Security Awareness**: Buffer protection and secure coding practices
6. **Mathematical Computing**: Floating-point and integer arithmetic operations
7. **Performance Optimization**: Efficient register usage and memory access patterns

## 🚀 Usage

### Prerequisites
- NASM (Netwide Assembler)
- Linux environment (programs use Linux system calls)
- Basic understanding of x86 architecture

### Compilation Example
```bash
nasm -f elf32 program.asm -o program.o
ld -m elf_i386 program.o -o program
./program
```

### Input Files
Some programs require input files (typically named `in.txt` or `in1.txt`) containing:
- Numerical data separated by spaces
- Text strings for processing
- Mathematical expressions

## 🎓 Educational Value

This repository serves as a comprehensive learning resource for:
- **Computer Science Students**: Understanding low-level programming concepts
- **System Programmers**: Learning direct hardware interaction
- **Security Researchers**: Studying buffer overflow protection techniques
- **Performance Engineers**: Optimizing code at the assembly level

## 📈 Code Quality Features

- **Consistent Commenting**: Clear documentation of program logic
- **Structured Code**: Logical organization and flow
- **Error Handling**: Robust input validation and error management
- **Reusable Components**: Modular function libraries
- **Multiple Paradigms**: Procedural and functional programming approaches

---

*This collection represents a comprehensive exploration of x86 Assembly programming, demonstrating both fundamental concepts and advanced techniques in low-level system programming.*

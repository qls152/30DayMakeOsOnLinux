void main() {
  char* vga = (char*)0xb8000;
  vga[1] = 'M';
}
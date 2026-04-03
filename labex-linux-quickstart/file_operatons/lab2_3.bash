# --- LAB 2 & 3: File Operations ---
echo "[Lab 02/03] File Operations Demo"
 
# Create a temp workspace
DEMO_DIR="/tmp/labex_demo_$$"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"
 
touch file1.txt file2.txt file3.txt
mkdir -p subdir/nested
 
echo "  Created files: $(ls *.txt | tr '\n' ' ')"
echo "  Created dirs : $(ls -d */ 2>/dev/null | tr '\n' ' ')"
 
cp file1.txt subdir/file1_copy.txt
mv file2.txt file2_renamed.txt
echo "  After cp+mv  : $(ls)"
 
# Cleanup
cd /tmp
rm -rf "$DEMO_DIR"
echo "  Demo cleanup done."
echo ""

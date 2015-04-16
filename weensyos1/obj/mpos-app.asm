
obj/mpos-app:     file format elf32-i386


Disassembly of section .text:

00200000 <app_printf>:

static void app_printf(const char *format, ...) __attribute__((noinline));

static void
app_printf(const char *format, ...)
{
  200000:	83 ec 0c             	sub    $0xc,%esp
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200003:	cd 30                	int    $0x30
static void
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
  200005:	85 c0                	test   %eax,%eax
  200007:	ba 00 07 00 00       	mov    $0x700,%edx
  20000c:	78 13                	js     200021 <app_printf+0x21>
		color = 0x0700;
	else {
		static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
		color = col[color % sizeof(col)] << 8;
  20000e:	b9 05 00 00 00       	mov    $0x5,%ecx
  200013:	31 d2                	xor    %edx,%edx
  200015:	f7 f1                	div    %ecx
  200017:	0f b6 92 70 06 20 00 	movzbl 0x200670(%edx),%edx
  20001e:	c1 e2 08             	shl    $0x8,%edx
	}

	va_list val;
	va_start(val, format);
	cursorpos = console_vprintf(cursorpos, color, format, val);
  200021:	8d 44 24 14          	lea    0x14(%esp),%eax
  200025:	50                   	push   %eax
  200026:	ff 74 24 14          	pushl  0x14(%esp)
  20002a:	52                   	push   %edx
  20002b:	ff 35 00 00 06 00    	pushl  0x60000
  200031:	e8 f5 01 00 00       	call   20022b <console_vprintf>
  200036:	a3 00 00 06 00       	mov    %eax,0x60000
	va_end(val);
}
  20003b:	83 c4 1c             	add    $0x1c,%esp
  20003e:	c3                   	ret    

0020003f <run_child>:
// }
// //=========end of Exercise 5===============

void
run_child(void)
{
  20003f:	83 ec 24             	sub    $0x24,%esp
	int i;
	volatile int checker = 1; /* This variable checks that you correctly
  200042:	c7 44 24 14 01 00 00 	movl   $0x1,0x14(%esp)
  200049:	00 
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  20004a:	cd 30                	int    $0x30
				     gave this process a new stack.
				     If the parent's 'checker' changed value
				     after the child ran, there's a problem! */

	app_printf("Child process %d!\n", sys_getpid());
  20004c:	50                   	push   %eax
  20004d:	68 e8 05 20 00       	push   $0x2005e8
  200052:	e8 a9 ff ff ff       	call   200000 <app_printf>
  200057:	31 c0                	xor    %eax,%eax
  200059:	83 c4 10             	add    $0x10,%esp

static inline void
sys_yield(void)
{
	// This system call has no return values, so there's no '=a' clause.
	asm volatile("int %0\n"
  20005c:	cd 32                	int    $0x32

	// Yield a couple times to help people test Exercise 3
	for (i = 0; i < 20; i++)
  20005e:	40                   	inc    %eax
  20005f:	83 f8 14             	cmp    $0x14,%eax
  200062:	75 f8                	jne    20005c <run_child+0x1d>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  200064:	66 b8 e8 03          	mov    $0x3e8,%ax
  200068:	cd 33                	int    $0x33
  20006a:	eb fe                	jmp    20006a <run_child+0x2b>

0020006c <start>:

void run_child(void);

void
start(void)
{
  20006c:	53                   	push   %ebx
  20006d:	83 ec 24             	sub    $0x24,%esp
	volatile int checker = 0; /* This variable checks that you correctly
  200070:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  200077:	00 
				     gave the child process a new stack. */
	pid_t p;
	int status;

	app_printf("About to start a new process...\n");
  200078:	68 fb 05 20 00       	push   $0x2005fb
  20007d:	e8 7e ff ff ff       	call   200000 <app_printf>
sys_fork(void)
{
	// This system call follows the same pattern as sys_getpid().

	pid_t result;
	asm volatile("int %1\n"
  200082:	cd 31                	int    $0x31

	p = sys_fork();
	if (p == 0)
  200084:	83 c4 10             	add    $0x10,%esp
  200087:	83 f8 00             	cmp    $0x0,%eax
  20008a:	89 c3                	mov    %eax,%ebx
  20008c:	75 09                	jne    200097 <start+0x2b>

	} else {
		app_printf("Error!\n");
		sys_exit(1);
	}
}
  20008e:	83 c4 18             	add    $0x18,%esp
  200091:	5b                   	pop    %ebx

	app_printf("About to start a new process...\n");

	p = sys_fork();
	if (p == 0)
		run_child();
  200092:	e9 a8 ff ff ff       	jmp    20003f <run_child>
	else if (p > 0) {
  200097:	7e 54                	jle    2000ed <start+0x81>
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200099:	cd 30                	int    $0x30
		app_printf("Main process %d!\n", sys_getpid());
  20009b:	52                   	push   %edx
  20009c:	52                   	push   %edx
  20009d:	50                   	push   %eax
  20009e:	68 1c 06 20 00       	push   $0x20061c
  2000a3:	e8 58 ff ff ff       	call   200000 <app_printf>
  2000a8:	83 c4 10             	add    $0x10,%esp

static inline int
sys_wait(pid_t pid)
{
	int retval;
	asm volatile("int %1\n"
  2000ab:	89 d8                	mov    %ebx,%eax
  2000ad:	cd 34                	int    $0x34
		do {
			status = sys_wait(p);
			//app_printf("W");
		} while (status == WAIT_TRYAGAIN);
  2000af:	83 f8 fe             	cmp    $0xfffffffe,%eax
  2000b2:	89 c2                	mov    %eax,%edx
  2000b4:	74 f5                	je     2000ab <start+0x3f>
		app_printf("Child %d exited with status %d!\n", p, status);
  2000b6:	50                   	push   %eax
  2000b7:	52                   	push   %edx
  2000b8:	53                   	push   %ebx
  2000b9:	68 2e 06 20 00       	push   $0x20062e
  2000be:	e8 3d ff ff ff       	call   200000 <app_printf>

		// Check whether the child process corrupted our stack.
		// (This check doesn't find all errors, but it helps.)
		if (checker != 0) {
  2000c3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  2000c7:	83 c4 10             	add    $0x10,%esp
  2000ca:	85 c0                	test   %eax,%eax
  2000cc:	74 19                	je     2000e7 <start+0x7b>
			app_printf("Error: stack collision!\n");
  2000ce:	83 ec 0c             	sub    $0xc,%esp
  2000d1:	68 4f 06 20 00       	push   $0x20064f
  2000d6:	e8 25 ff ff ff       	call   200000 <app_printf>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  2000db:	b8 01 00 00 00       	mov    $0x1,%eax
  2000e0:	cd 33                	int    $0x33
  2000e2:	83 c4 10             	add    $0x10,%esp
  2000e5:	eb fe                	jmp    2000e5 <start+0x79>
  2000e7:	31 c0                	xor    %eax,%eax
  2000e9:	cd 33                	int    $0x33
  2000eb:	eb fe                	jmp    2000eb <start+0x7f>
			sys_exit(1);
		} else
			sys_exit(0);

	} else {
		app_printf("Error!\n");
  2000ed:	83 ec 0c             	sub    $0xc,%esp
  2000f0:	68 68 06 20 00       	push   $0x200668
  2000f5:	e8 06 ff ff ff       	call   200000 <app_printf>
  2000fa:	b8 01 00 00 00       	mov    $0x1,%eax
  2000ff:	cd 33                	int    $0x33
  200101:	83 c4 10             	add    $0x10,%esp
  200104:	eb fe                	jmp    200104 <start+0x98>
  200106:	90                   	nop
  200107:	90                   	nop

00200108 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  200108:	56                   	push   %esi
  200109:	31 d2                	xor    %edx,%edx
  20010b:	53                   	push   %ebx
  20010c:	8b 44 24 0c          	mov    0xc(%esp),%eax
  200110:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  200114:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  200118:	eb 08                	jmp    200122 <memcpy+0x1a>
		*d++ = *s++;
  20011a:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  20011d:	4e                   	dec    %esi
  20011e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  200121:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  200122:	85 f6                	test   %esi,%esi
  200124:	75 f4                	jne    20011a <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  200126:	5b                   	pop    %ebx
  200127:	5e                   	pop    %esi
  200128:	c3                   	ret    

00200129 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  200129:	57                   	push   %edi
  20012a:	56                   	push   %esi
  20012b:	53                   	push   %ebx
  20012c:	8b 44 24 10          	mov    0x10(%esp),%eax
  200130:	8b 7c 24 14          	mov    0x14(%esp),%edi
  200134:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  200138:	39 c7                	cmp    %eax,%edi
  20013a:	73 26                	jae    200162 <memmove+0x39>
  20013c:	8d 34 17             	lea    (%edi,%edx,1),%esi
  20013f:	39 c6                	cmp    %eax,%esi
  200141:	76 1f                	jbe    200162 <memmove+0x39>
		s += n, d += n;
  200143:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  200146:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  200148:	eb 07                	jmp    200151 <memmove+0x28>
			*--d = *--s;
  20014a:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  20014d:	4a                   	dec    %edx
  20014e:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  200151:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  200152:	85 d2                	test   %edx,%edx
  200154:	75 f4                	jne    20014a <memmove+0x21>
  200156:	eb 10                	jmp    200168 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  200158:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  20015b:	4a                   	dec    %edx
  20015c:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  20015f:	41                   	inc    %ecx
  200160:	eb 02                	jmp    200164 <memmove+0x3b>
  200162:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  200164:	85 d2                	test   %edx,%edx
  200166:	75 f0                	jne    200158 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  200168:	5b                   	pop    %ebx
  200169:	5e                   	pop    %esi
  20016a:	5f                   	pop    %edi
  20016b:	c3                   	ret    

0020016c <memset>:

void *
memset(void *v, int c, size_t n)
{
  20016c:	53                   	push   %ebx
  20016d:	8b 44 24 08          	mov    0x8(%esp),%eax
  200171:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  200175:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  200179:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  20017b:	eb 04                	jmp    200181 <memset+0x15>
		*p++ = c;
  20017d:	88 1a                	mov    %bl,(%edx)
  20017f:	49                   	dec    %ecx
  200180:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  200181:	85 c9                	test   %ecx,%ecx
  200183:	75 f8                	jne    20017d <memset+0x11>
		*p++ = c;
	return v;
}
  200185:	5b                   	pop    %ebx
  200186:	c3                   	ret    

00200187 <strlen>:

size_t
strlen(const char *s)
{
  200187:	8b 54 24 04          	mov    0x4(%esp),%edx
  20018b:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20018d:	eb 01                	jmp    200190 <strlen+0x9>
		++n;
  20018f:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  200190:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  200194:	75 f9                	jne    20018f <strlen+0x8>
		++n;
	return n;
}
  200196:	c3                   	ret    

00200197 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  200197:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  20019b:	31 c0                	xor    %eax,%eax
  20019d:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  2001a1:	eb 01                	jmp    2001a4 <strnlen+0xd>
		++n;
  2001a3:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  2001a4:	39 d0                	cmp    %edx,%eax
  2001a6:	74 06                	je     2001ae <strnlen+0x17>
  2001a8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  2001ac:	75 f5                	jne    2001a3 <strnlen+0xc>
		++n;
	return n;
}
  2001ae:	c3                   	ret    

002001af <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  2001af:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  2001b0:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  2001b5:	53                   	push   %ebx
  2001b6:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  2001b8:	76 05                	jbe    2001bf <console_putc+0x10>
  2001ba:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  2001bf:	80 fa 0a             	cmp    $0xa,%dl
  2001c2:	75 2c                	jne    2001f0 <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  2001c4:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  2001ca:	be 50 00 00 00       	mov    $0x50,%esi
  2001cf:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  2001d1:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  2001d4:	99                   	cltd   
  2001d5:	f7 fe                	idiv   %esi
  2001d7:	89 de                	mov    %ebx,%esi
  2001d9:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  2001db:	eb 07                	jmp    2001e4 <console_putc+0x35>
			*cursor++ = ' ' | color;
  2001dd:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  2001e0:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  2001e1:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  2001e4:	83 f8 50             	cmp    $0x50,%eax
  2001e7:	75 f4                	jne    2001dd <console_putc+0x2e>
  2001e9:	29 d0                	sub    %edx,%eax
  2001eb:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  2001ee:	eb 0b                	jmp    2001fb <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2001f0:	0f b6 d2             	movzbl %dl,%edx
  2001f3:	09 ca                	or     %ecx,%edx
  2001f5:	66 89 13             	mov    %dx,(%ebx)
  2001f8:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  2001fb:	5b                   	pop    %ebx
  2001fc:	5e                   	pop    %esi
  2001fd:	c3                   	ret    

002001fe <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  2001fe:	56                   	push   %esi
  2001ff:	53                   	push   %ebx
  200200:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  200204:	8d 58 ff             	lea    -0x1(%eax),%ebx
  200207:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  20020b:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  200210:	75 04                	jne    200216 <fill_numbuf+0x18>
  200212:	85 d2                	test   %edx,%edx
  200214:	74 10                	je     200226 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  200216:	89 d0                	mov    %edx,%eax
  200218:	31 d2                	xor    %edx,%edx
  20021a:	f7 f1                	div    %ecx
  20021c:	4b                   	dec    %ebx
  20021d:	8a 14 16             	mov    (%esi,%edx,1),%dl
  200220:	88 13                	mov    %dl,(%ebx)
			val /= base;
  200222:	89 c2                	mov    %eax,%edx
  200224:	eb ec                	jmp    200212 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  200226:	89 d8                	mov    %ebx,%eax
  200228:	5b                   	pop    %ebx
  200229:	5e                   	pop    %esi
  20022a:	c3                   	ret    

0020022b <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  20022b:	55                   	push   %ebp
  20022c:	57                   	push   %edi
  20022d:	56                   	push   %esi
  20022e:	53                   	push   %ebx
  20022f:	83 ec 38             	sub    $0x38,%esp
  200232:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  200236:	8b 7c 24 54          	mov    0x54(%esp),%edi
  20023a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  20023e:	e9 60 03 00 00       	jmp    2005a3 <console_vprintf+0x378>
		if (*format != '%') {
  200243:	80 fa 25             	cmp    $0x25,%dl
  200246:	74 13                	je     20025b <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  200248:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  20024c:	0f b6 d2             	movzbl %dl,%edx
  20024f:	89 f0                	mov    %esi,%eax
  200251:	e8 59 ff ff ff       	call   2001af <console_putc>
  200256:	e9 45 03 00 00       	jmp    2005a0 <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  20025b:	47                   	inc    %edi
  20025c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  200263:	00 
  200264:	eb 12                	jmp    200278 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  200266:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  200267:	8a 11                	mov    (%ecx),%dl
  200269:	84 d2                	test   %dl,%dl
  20026b:	74 1a                	je     200287 <console_vprintf+0x5c>
  20026d:	89 e8                	mov    %ebp,%eax
  20026f:	38 c2                	cmp    %al,%dl
  200271:	75 f3                	jne    200266 <console_vprintf+0x3b>
  200273:	e9 3f 03 00 00       	jmp    2005b7 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200278:	8a 17                	mov    (%edi),%dl
  20027a:	84 d2                	test   %dl,%dl
  20027c:	74 0b                	je     200289 <console_vprintf+0x5e>
  20027e:	b9 78 06 20 00       	mov    $0x200678,%ecx
  200283:	89 d5                	mov    %edx,%ebp
  200285:	eb e0                	jmp    200267 <console_vprintf+0x3c>
  200287:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  200289:	8d 42 cf             	lea    -0x31(%edx),%eax
  20028c:	3c 08                	cmp    $0x8,%al
  20028e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  200295:	00 
  200296:	76 13                	jbe    2002ab <console_vprintf+0x80>
  200298:	eb 1d                	jmp    2002b7 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  20029a:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  20029f:	0f be c0             	movsbl %al,%eax
  2002a2:	47                   	inc    %edi
  2002a3:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  2002a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  2002ab:	8a 07                	mov    (%edi),%al
  2002ad:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002b0:	80 fa 09             	cmp    $0x9,%dl
  2002b3:	76 e5                	jbe    20029a <console_vprintf+0x6f>
  2002b5:	eb 18                	jmp    2002cf <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  2002b7:	80 fa 2a             	cmp    $0x2a,%dl
  2002ba:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  2002c1:	ff 
  2002c2:	75 0b                	jne    2002cf <console_vprintf+0xa4>
			width = va_arg(val, int);
  2002c4:	83 c3 04             	add    $0x4,%ebx
			++format;
  2002c7:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  2002c8:	8b 53 fc             	mov    -0x4(%ebx),%edx
  2002cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  2002cf:	83 cd ff             	or     $0xffffffff,%ebp
  2002d2:	80 3f 2e             	cmpb   $0x2e,(%edi)
  2002d5:	75 37                	jne    20030e <console_vprintf+0xe3>
			++format;
  2002d7:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  2002d8:	31 ed                	xor    %ebp,%ebp
  2002da:	8a 07                	mov    (%edi),%al
  2002dc:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002df:	80 fa 09             	cmp    $0x9,%dl
  2002e2:	76 0d                	jbe    2002f1 <console_vprintf+0xc6>
  2002e4:	eb 17                	jmp    2002fd <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  2002e6:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  2002e9:	0f be c0             	movsbl %al,%eax
  2002ec:	47                   	inc    %edi
  2002ed:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  2002f1:	8a 07                	mov    (%edi),%al
  2002f3:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002f6:	80 fa 09             	cmp    $0x9,%dl
  2002f9:	76 eb                	jbe    2002e6 <console_vprintf+0xbb>
  2002fb:	eb 11                	jmp    20030e <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  2002fd:	3c 2a                	cmp    $0x2a,%al
  2002ff:	75 0b                	jne    20030c <console_vprintf+0xe1>
				precision = va_arg(val, int);
  200301:	83 c3 04             	add    $0x4,%ebx
				++format;
  200304:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  200305:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  200308:	85 ed                	test   %ebp,%ebp
  20030a:	79 02                	jns    20030e <console_vprintf+0xe3>
  20030c:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  20030e:	8a 07                	mov    (%edi),%al
  200310:	3c 64                	cmp    $0x64,%al
  200312:	74 34                	je     200348 <console_vprintf+0x11d>
  200314:	7f 1d                	jg     200333 <console_vprintf+0x108>
  200316:	3c 58                	cmp    $0x58,%al
  200318:	0f 84 a2 00 00 00    	je     2003c0 <console_vprintf+0x195>
  20031e:	3c 63                	cmp    $0x63,%al
  200320:	0f 84 bf 00 00 00    	je     2003e5 <console_vprintf+0x1ba>
  200326:	3c 43                	cmp    $0x43,%al
  200328:	0f 85 d0 00 00 00    	jne    2003fe <console_vprintf+0x1d3>
  20032e:	e9 a3 00 00 00       	jmp    2003d6 <console_vprintf+0x1ab>
  200333:	3c 75                	cmp    $0x75,%al
  200335:	74 4d                	je     200384 <console_vprintf+0x159>
  200337:	3c 78                	cmp    $0x78,%al
  200339:	74 5c                	je     200397 <console_vprintf+0x16c>
  20033b:	3c 73                	cmp    $0x73,%al
  20033d:	0f 85 bb 00 00 00    	jne    2003fe <console_vprintf+0x1d3>
  200343:	e9 86 00 00 00       	jmp    2003ce <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  200348:	83 c3 04             	add    $0x4,%ebx
  20034b:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  20034e:	89 d1                	mov    %edx,%ecx
  200350:	c1 f9 1f             	sar    $0x1f,%ecx
  200353:	89 0c 24             	mov    %ecx,(%esp)
  200356:	31 ca                	xor    %ecx,%edx
  200358:	55                   	push   %ebp
  200359:	29 ca                	sub    %ecx,%edx
  20035b:	68 80 06 20 00       	push   $0x200680
  200360:	b9 0a 00 00 00       	mov    $0xa,%ecx
  200365:	8d 44 24 40          	lea    0x40(%esp),%eax
  200369:	e8 90 fe ff ff       	call   2001fe <fill_numbuf>
  20036e:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  200372:	58                   	pop    %eax
  200373:	5a                   	pop    %edx
  200374:	ba 01 00 00 00       	mov    $0x1,%edx
  200379:	8b 04 24             	mov    (%esp),%eax
  20037c:	83 e0 01             	and    $0x1,%eax
  20037f:	e9 a5 00 00 00       	jmp    200429 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  200384:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  200387:	b9 0a 00 00 00       	mov    $0xa,%ecx
  20038c:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20038f:	55                   	push   %ebp
  200390:	68 80 06 20 00       	push   $0x200680
  200395:	eb 11                	jmp    2003a8 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  200397:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  20039a:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20039d:	55                   	push   %ebp
  20039e:	68 94 06 20 00       	push   $0x200694
  2003a3:	b9 10 00 00 00       	mov    $0x10,%ecx
  2003a8:	8d 44 24 40          	lea    0x40(%esp),%eax
  2003ac:	e8 4d fe ff ff       	call   2001fe <fill_numbuf>
  2003b1:	ba 01 00 00 00       	mov    $0x1,%edx
  2003b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2003ba:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  2003bc:	59                   	pop    %ecx
  2003bd:	59                   	pop    %ecx
  2003be:	eb 69                	jmp    200429 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  2003c0:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  2003c3:	8b 53 fc             	mov    -0x4(%ebx),%edx
  2003c6:	55                   	push   %ebp
  2003c7:	68 80 06 20 00       	push   $0x200680
  2003cc:	eb d5                	jmp    2003a3 <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  2003ce:	83 c3 04             	add    $0x4,%ebx
  2003d1:	8b 43 fc             	mov    -0x4(%ebx),%eax
  2003d4:	eb 40                	jmp    200416 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  2003d6:	83 c3 04             	add    $0x4,%ebx
  2003d9:	8b 53 fc             	mov    -0x4(%ebx),%edx
  2003dc:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  2003e0:	e9 bd 01 00 00       	jmp    2005a2 <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003e5:	83 c3 04             	add    $0x4,%ebx
  2003e8:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  2003eb:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  2003ef:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  2003f4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003f8:	88 44 24 24          	mov    %al,0x24(%esp)
  2003fc:	eb 27                	jmp    200425 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  2003fe:	84 c0                	test   %al,%al
  200400:	75 02                	jne    200404 <console_vprintf+0x1d9>
  200402:	b0 25                	mov    $0x25,%al
  200404:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  200408:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  20040d:	80 3f 00             	cmpb   $0x0,(%edi)
  200410:	74 0a                	je     20041c <console_vprintf+0x1f1>
  200412:	8d 44 24 24          	lea    0x24(%esp),%eax
  200416:	89 44 24 04          	mov    %eax,0x4(%esp)
  20041a:	eb 09                	jmp    200425 <console_vprintf+0x1fa>
				format--;
  20041c:	8d 54 24 24          	lea    0x24(%esp),%edx
  200420:	4f                   	dec    %edi
  200421:	89 54 24 04          	mov    %edx,0x4(%esp)
  200425:	31 d2                	xor    %edx,%edx
  200427:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  200429:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  20042b:	83 fd ff             	cmp    $0xffffffff,%ebp
  20042e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  200435:	74 1f                	je     200456 <console_vprintf+0x22b>
  200437:	89 04 24             	mov    %eax,(%esp)
  20043a:	eb 01                	jmp    20043d <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  20043c:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  20043d:	39 e9                	cmp    %ebp,%ecx
  20043f:	74 0a                	je     20044b <console_vprintf+0x220>
  200441:	8b 44 24 04          	mov    0x4(%esp),%eax
  200445:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  200449:	75 f1                	jne    20043c <console_vprintf+0x211>
  20044b:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  20044e:	89 0c 24             	mov    %ecx,(%esp)
  200451:	eb 1f                	jmp    200472 <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  200453:	42                   	inc    %edx
  200454:	eb 09                	jmp    20045f <console_vprintf+0x234>
  200456:	89 d1                	mov    %edx,%ecx
  200458:	8b 14 24             	mov    (%esp),%edx
  20045b:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20045f:	8b 44 24 04          	mov    0x4(%esp),%eax
  200463:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  200467:	75 ea                	jne    200453 <console_vprintf+0x228>
  200469:	8b 44 24 08          	mov    0x8(%esp),%eax
  20046d:	89 14 24             	mov    %edx,(%esp)
  200470:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  200472:	85 c0                	test   %eax,%eax
  200474:	74 0c                	je     200482 <console_vprintf+0x257>
  200476:	84 d2                	test   %dl,%dl
  200478:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  20047f:	00 
  200480:	75 24                	jne    2004a6 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  200482:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  200487:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  20048e:	00 
  20048f:	75 15                	jne    2004a6 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  200491:	8b 44 24 14          	mov    0x14(%esp),%eax
  200495:	83 e0 08             	and    $0x8,%eax
  200498:	83 f8 01             	cmp    $0x1,%eax
  20049b:	19 c9                	sbb    %ecx,%ecx
  20049d:	f7 d1                	not    %ecx
  20049f:	83 e1 20             	and    $0x20,%ecx
  2004a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  2004a6:	3b 2c 24             	cmp    (%esp),%ebp
  2004a9:	7e 0d                	jle    2004b8 <console_vprintf+0x28d>
  2004ab:	84 d2                	test   %dl,%dl
  2004ad:	74 40                	je     2004ef <console_vprintf+0x2c4>
			zeros = precision - len;
  2004af:	2b 2c 24             	sub    (%esp),%ebp
  2004b2:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  2004b6:	eb 3f                	jmp    2004f7 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004b8:	84 d2                	test   %dl,%dl
  2004ba:	74 33                	je     2004ef <console_vprintf+0x2c4>
  2004bc:	8b 44 24 14          	mov    0x14(%esp),%eax
  2004c0:	83 e0 06             	and    $0x6,%eax
  2004c3:	83 f8 02             	cmp    $0x2,%eax
  2004c6:	75 27                	jne    2004ef <console_vprintf+0x2c4>
  2004c8:	45                   	inc    %ebp
  2004c9:	75 24                	jne    2004ef <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  2004cb:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004cd:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  2004d0:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  2004d5:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004d8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  2004db:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  2004df:	7d 0e                	jge    2004ef <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  2004e1:	8b 54 24 0c          	mov    0xc(%esp),%edx
  2004e5:	29 ca                	sub    %ecx,%edx
  2004e7:	29 c2                	sub    %eax,%edx
  2004e9:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004ed:	eb 08                	jmp    2004f7 <console_vprintf+0x2cc>
  2004ef:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  2004f6:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004f7:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  2004fb:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004fd:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  200501:	2b 2c 24             	sub    (%esp),%ebp
  200504:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  200509:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  20050c:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  20050f:	29 c5                	sub    %eax,%ebp
  200511:	89 f0                	mov    %esi,%eax
  200513:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  200517:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  20051b:	eb 0f                	jmp    20052c <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  20051d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200521:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  200526:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  200527:	e8 83 fc ff ff       	call   2001af <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  20052c:	85 ed                	test   %ebp,%ebp
  20052e:	7e 07                	jle    200537 <console_vprintf+0x30c>
  200530:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  200535:	74 e6                	je     20051d <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  200537:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  20053c:	89 c6                	mov    %eax,%esi
  20053e:	74 23                	je     200563 <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  200540:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  200545:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200549:	e8 61 fc ff ff       	call   2001af <console_putc>
  20054e:	89 c6                	mov    %eax,%esi
  200550:	eb 11                	jmp    200563 <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  200552:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200556:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  20055b:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  20055c:	e8 4e fc ff ff       	call   2001af <console_putc>
  200561:	eb 06                	jmp    200569 <console_vprintf+0x33e>
  200563:	89 f0                	mov    %esi,%eax
  200565:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200569:	85 f6                	test   %esi,%esi
  20056b:	7f e5                	jg     200552 <console_vprintf+0x327>
  20056d:	8b 34 24             	mov    (%esp),%esi
  200570:	eb 15                	jmp    200587 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  200572:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200576:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  200577:	0f b6 11             	movzbl (%ecx),%edx
  20057a:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  20057e:	e8 2c fc ff ff       	call   2001af <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200583:	ff 44 24 04          	incl   0x4(%esp)
  200587:	85 f6                	test   %esi,%esi
  200589:	7f e7                	jg     200572 <console_vprintf+0x347>
  20058b:	eb 0f                	jmp    20059c <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  20058d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200591:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  200596:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  200597:	e8 13 fc ff ff       	call   2001af <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  20059c:	85 ed                	test   %ebp,%ebp
  20059e:	7f ed                	jg     20058d <console_vprintf+0x362>
  2005a0:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  2005a2:	47                   	inc    %edi
  2005a3:	8a 17                	mov    (%edi),%dl
  2005a5:	84 d2                	test   %dl,%dl
  2005a7:	0f 85 96 fc ff ff    	jne    200243 <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  2005ad:	83 c4 38             	add    $0x38,%esp
  2005b0:	89 f0                	mov    %esi,%eax
  2005b2:	5b                   	pop    %ebx
  2005b3:	5e                   	pop    %esi
  2005b4:	5f                   	pop    %edi
  2005b5:	5d                   	pop    %ebp
  2005b6:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  2005b7:	81 e9 78 06 20 00    	sub    $0x200678,%ecx
  2005bd:	b8 01 00 00 00       	mov    $0x1,%eax
  2005c2:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  2005c4:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  2005c5:	09 44 24 14          	or     %eax,0x14(%esp)
  2005c9:	e9 aa fc ff ff       	jmp    200278 <console_vprintf+0x4d>

002005ce <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  2005ce:	8d 44 24 10          	lea    0x10(%esp),%eax
  2005d2:	50                   	push   %eax
  2005d3:	ff 74 24 10          	pushl  0x10(%esp)
  2005d7:	ff 74 24 10          	pushl  0x10(%esp)
  2005db:	ff 74 24 10          	pushl  0x10(%esp)
  2005df:	e8 47 fc ff ff       	call   20022b <console_vprintf>
  2005e4:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  2005e7:	c3                   	ret    


obj/mpos-kern:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4 bc                	in     $0xbc,%al

0010000c <multiboot_start>:
# The multiboot_start routine sets the stack pointer to the top of the
# MiniprocOS's kernel stack, then jumps to the 'start' routine in mpos-kern.c.

.globl multiboot_start
multiboot_start:
	movl $0x200000, %esp
  10000c:	bc 00 00 20 00       	mov    $0x200000,%esp
	pushl $0
  100011:	6a 00                	push   $0x0
	popfl
  100013:	9d                   	popf   
	call start
  100014:	e8 fc 01 00 00       	call   100215 <start>
  100019:	90                   	nop

0010001a <sys_int48_handler>:

# Interrupt handlers
.align 2

sys_int48_handler:
	pushl $0
  10001a:	6a 00                	push   $0x0
	pushl $48
  10001c:	6a 30                	push   $0x30
	jmp _generic_int_handler
  10001e:	eb 3a                	jmp    10005a <_generic_int_handler>

00100020 <sys_int49_handler>:

sys_int49_handler:
	pushl $0
  100020:	6a 00                	push   $0x0
	pushl $49
  100022:	6a 31                	push   $0x31
	jmp _generic_int_handler
  100024:	eb 34                	jmp    10005a <_generic_int_handler>

00100026 <sys_int50_handler>:

sys_int50_handler:
	pushl $0
  100026:	6a 00                	push   $0x0
	pushl $50
  100028:	6a 32                	push   $0x32
	jmp _generic_int_handler
  10002a:	eb 2e                	jmp    10005a <_generic_int_handler>

0010002c <sys_int51_handler>:

sys_int51_handler:
	pushl $0
  10002c:	6a 00                	push   $0x0
	pushl $51
  10002e:	6a 33                	push   $0x33
	jmp _generic_int_handler
  100030:	eb 28                	jmp    10005a <_generic_int_handler>

00100032 <sys_int52_handler>:

sys_int52_handler:
	pushl $0
  100032:	6a 00                	push   $0x0
	pushl $52
  100034:	6a 34                	push   $0x34
	jmp _generic_int_handler
  100036:	eb 22                	jmp    10005a <_generic_int_handler>

00100038 <sys_int53_handler>:

sys_int53_handler:
	pushl $0
  100038:	6a 00                	push   $0x0
	pushl $53
  10003a:	6a 35                	push   $0x35
	jmp _generic_int_handler
  10003c:	eb 1c                	jmp    10005a <_generic_int_handler>

0010003e <sys_int54_handler>:

sys_int54_handler:
	pushl $0
  10003e:	6a 00                	push   $0x0
	pushl $54
  100040:	6a 36                	push   $0x36
	jmp _generic_int_handler
  100042:	eb 16                	jmp    10005a <_generic_int_handler>

00100044 <sys_int55_handler>:

sys_int55_handler:
	pushl $0
  100044:	6a 00                	push   $0x0
	pushl $55
  100046:	6a 37                	push   $0x37
	jmp _generic_int_handler
  100048:	eb 10                	jmp    10005a <_generic_int_handler>

0010004a <sys_int56_handler>:

sys_int56_handler:
	pushl $0
  10004a:	6a 00                	push   $0x0
	pushl $56
  10004c:	6a 38                	push   $0x38
	jmp _generic_int_handler
  10004e:	eb 0a                	jmp    10005a <_generic_int_handler>

00100050 <sys_int57_handler>:

sys_int57_handler:
	pushl $0
  100050:	6a 00                	push   $0x0
	pushl $57
  100052:	6a 39                	push   $0x39
	jmp _generic_int_handler
  100054:	eb 04                	jmp    10005a <_generic_int_handler>

00100056 <default_int_handler>:

	.globl default_int_handler
default_int_handler:
	pushl $0
  100056:	6a 00                	push   $0x0
	jmp _generic_int_handler
  100058:	eb 00                	jmp    10005a <_generic_int_handler>

0010005a <_generic_int_handler>:
	# When we get here, the processor's interrupt mechanism has
	# pushed the old task status and stack registers onto the kernel stack.
	# Then one of the specific handlers pushed the interrupt number.
	# Now, we complete the 'registers_t' structure by pushing the extra
	# segment definitions and the general CPU registers.
	pushl %ds
  10005a:	1e                   	push   %ds
	pushl %es
  10005b:	06                   	push   %es
	pushal
  10005c:	60                   	pusha  

	# Call the kernel's 'interrupt' function.
	pushl %esp
  10005d:	54                   	push   %esp
	call interrupt
  10005e:	e8 58 00 00 00       	call   1000bb <interrupt>

00100063 <sys_int_handlers>:
  100063:	1a 00                	sbb    (%eax),%al
  100065:	10 00                	adc    %al,(%eax)
  100067:	20 00                	and    %al,(%eax)
  100069:	10 00                	adc    %al,(%eax)
  10006b:	26 00 10             	add    %dl,%es:(%eax)
  10006e:	00 2c 00             	add    %ch,(%eax,%eax,1)
  100071:	10 00                	adc    %al,(%eax)
  100073:	32 00                	xor    (%eax),%al
  100075:	10 00                	adc    %al,(%eax)
  100077:	38 00                	cmp    %al,(%eax)
  100079:	10 00                	adc    %al,(%eax)
  10007b:	3e 00 10             	add    %dl,%ds:(%eax)
  10007e:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
  100082:	00 4a 00             	add    %cl,0x0(%edx)
  100085:	10 00                	adc    %al,(%eax)
  100087:	50                   	push   %eax
  100088:	00 10                	add    %dl,(%eax)
  10008a:	00 90 83 ec 0c a1    	add    %dl,-0x5ef3137d(%eax)

0010008c <schedule>:
 *
 *****************************************************************************/

void
schedule(void)
{
  10008c:	83 ec 0c             	sub    $0xc,%esp
	pid_t pid = current->p_pid;
  10008f:	a1 18 9f 10 00       	mov    0x109f18,%eax
	while (1) {
		pid = (pid + 1) % NPROCS;
  100094:	b9 10 00 00 00       	mov    $0x10,%ecx
 *****************************************************************************/

void
schedule(void)
{
	pid_t pid = current->p_pid;
  100099:	8b 10                	mov    (%eax),%edx
	while (1) {
		pid = (pid + 1) % NPROCS;
  10009b:	8d 42 01             	lea    0x1(%edx),%eax
  10009e:	99                   	cltd   
  10009f:	f7 f9                	idiv   %ecx
		if (proc_array[pid].p_state == P_RUNNABLE)
  1000a1:	6b c2 54             	imul   $0x54,%edx,%eax
  1000a4:	83 b8 b8 91 10 00 01 	cmpl   $0x1,0x1091b8(%eax)
  1000ab:	75 ee                	jne    10009b <schedule+0xf>
			run(&proc_array[pid]);
  1000ad:	83 ec 0c             	sub    $0xc,%esp
  1000b0:	05 70 91 10 00       	add    $0x109170,%eax
  1000b5:	50                   	push   %eax
  1000b6:	e8 75 03 00 00       	call   100430 <run>

001000bb <interrupt>:
static pid_t do_fork(process_t *parent);
static pid_t new_thread(process_t* parent);

void
interrupt(registers_t *reg)
{
  1000bb:	55                   	push   %ebp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000bc:	b9 11 00 00 00       	mov    $0x11,%ecx
static pid_t do_fork(process_t *parent);
static pid_t new_thread(process_t* parent);

void
interrupt(registers_t *reg)
{
  1000c1:	57                   	push   %edi
  1000c2:	56                   	push   %esi
  1000c3:	53                   	push   %ebx
  1000c4:	83 ec 0c             	sub    $0xc,%esp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000c7:	8b 1d 18 9f 10 00    	mov    0x109f18,%ebx
static pid_t do_fork(process_t *parent);
static pid_t new_thread(process_t* parent);

void
interrupt(registers_t *reg)
{
  1000cd:	8b 44 24 20          	mov    0x20(%esp),%eax
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000d1:	8d 7b 04             	lea    0x4(%ebx),%edi
  1000d4:	89 c6                	mov    %eax,%esi
  1000d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	switch (reg->reg_intno) {
  1000d8:	8b 40 28             	mov    0x28(%eax),%eax
  1000db:	83 e8 30             	sub    $0x30,%eax
  1000de:	83 f8 04             	cmp    $0x4,%eax
  1000e1:	0f 87 2c 01 00 00    	ja     100213 <interrupt+0x158>
  1000e7:	ff 24 85 e8 09 10 00 	jmp    *0x1009e8(,%eax,4)
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1000ee:	8b 03                	mov    (%ebx),%eax
		run(current);
  1000f0:	83 ec 0c             	sub    $0xc,%esp
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1000f3:	89 43 20             	mov    %eax,0x20(%ebx)
		run(current);
  1000f6:	53                   	push   %ebx
  1000f7:	e9 92 00 00 00       	jmp    10018e <interrupt+0xd3>
	//   * reg_eax    There is one other difference.  What is it?  (Hint:
	//                What should sys_fork() return to the child process?)
	// You need to set one other process descriptor field as well.
	// Finally, return the child's process ID to the parent.

	pid_t childpid = parent->p_pid+1;
  1000fc:	8b 0b                	mov    (%ebx),%ecx
	while((proc_array[childpid].p_state!=P_EMPTY && childpid!=parent->p_pid ) || childpid==0){
		childpid = (childpid+1)%NPROCS;
  1000fe:	be 10 00 00 00       	mov    $0x10,%esi
	//   * reg_eax    There is one other difference.  What is it?  (Hint:
	//                What should sys_fork() return to the child process?)
	// You need to set one other process descriptor field as well.
	// Finally, return the child's process ID to the parent.

	pid_t childpid = parent->p_pid+1;
  100103:	8d 69 01             	lea    0x1(%ecx),%ebp
  100106:	eb 08                	jmp    100110 <interrupt+0x55>
	while((proc_array[childpid].p_state!=P_EMPTY && childpid!=parent->p_pid ) || childpid==0){
		childpid = (childpid+1)%NPROCS;
  100108:	8d 45 01             	lea    0x1(%ebp),%eax
  10010b:	99                   	cltd   
  10010c:	f7 fe                	idiv   %esi
  10010e:	89 d5                	mov    %edx,%ebp
	//                What should sys_fork() return to the child process?)
	// You need to set one other process descriptor field as well.
	// Finally, return the child's process ID to the parent.

	pid_t childpid = parent->p_pid+1;
	while((proc_array[childpid].p_state!=P_EMPTY && childpid!=parent->p_pid ) || childpid==0){
  100110:	6b c5 54             	imul   $0x54,%ebp,%eax
  100113:	83 b8 b8 91 10 00 00 	cmpl   $0x0,0x1091b8(%eax)
  10011a:	74 04                	je     100120 <interrupt+0x65>
  10011c:	39 cd                	cmp    %ecx,%ebp
  10011e:	75 e8                	jne    100108 <interrupt+0x4d>
  100120:	85 ed                	test   %ebp,%ebp
  100122:	74 e4                	je     100108 <interrupt+0x4d>
		childpid = (childpid+1)%NPROCS;
	}
	if(childpid==parent->p_pid)
  100124:	39 cd                	cmp    %ecx,%ebp
  100126:	75 05                	jne    10012d <interrupt+0x72>
  100128:	83 cd ff             	or     $0xffffffff,%ebp
  10012b:	eb 55                	jmp    100182 <interrupt+0xc7>
		return -1;
	process_t *child = &proc_array[childpid];
  10012d:	6b d5 54             	imul   $0x54,%ebp,%edx
	child->p_pid = childpid;
	child->p_registers = parent->p_registers;
  100130:	b9 11 00 00 00       	mov    $0x11,%ecx
  100135:	8d 73 04             	lea    0x4(%ebx),%esi
	while((proc_array[childpid].p_state!=P_EMPTY && childpid!=parent->p_pid ) || childpid==0){
		childpid = (childpid+1)%NPROCS;
	}
	if(childpid==parent->p_pid)
		return -1;
	process_t *child = &proc_array[childpid];
  100138:	8d 82 70 91 10 00    	lea    0x109170(%edx),%eax
	child->p_pid = childpid;
	child->p_registers = parent->p_registers;
  10013e:	8d 78 04             	lea    0x4(%eax),%edi
  100141:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	// YOUR CODE HERE!

	src_stack_top = PROC1_STACK_ADDR + src->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + dest->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  100143:	8d 4d 0a             	lea    0xa(%ebp),%ecx
		childpid = (childpid+1)%NPROCS;
	}
	if(childpid==parent->p_pid)
		return -1;
	process_t *child = &proc_array[childpid];
	child->p_pid = childpid;
  100146:	89 aa 70 91 10 00    	mov    %ebp,0x109170(%edx)
	// and then how to actually copy the stack.  (Hint: use memcpy.)
	// We have done one for you.

	// YOUR CODE HERE!

	src_stack_top = PROC1_STACK_ADDR + src->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  10014c:	8b 13                	mov    (%ebx),%edx
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + dest->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  10014e:	c1 e1 12             	shl    $0x12,%ecx
	if(childpid==parent->p_pid)
		return -1;
	process_t *child = &proc_array[childpid];
	child->p_pid = childpid;
	child->p_registers = parent->p_registers;
	child->p_registers.reg_eax = 0;
  100151:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
	// We have done one for you.

	// YOUR CODE HERE!

	src_stack_top = PROC1_STACK_ADDR + src->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	src_stack_bottom = src->p_registers.reg_esp;
  100158:	8b 73 40             	mov    0x40(%ebx),%esi
		return -1;
	process_t *child = &proc_array[childpid];
	child->p_pid = childpid;
	child->p_registers = parent->p_registers;
	child->p_registers.reg_eax = 0;
	child->p_state = P_RUNNABLE;
  10015b:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%eax)
	// and then how to actually copy the stack.  (Hint: use memcpy.)
	// We have done one for you.

	// YOUR CODE HERE!

	src_stack_top = PROC1_STACK_ADDR + src->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  100162:	83 c2 0a             	add    $0xa,%edx
  100165:	c1 e2 12             	shl    $0x12,%edx
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + dest->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	dest_stack_bottom = dest_stack_top + (src_stack_bottom - src_stack_top); /* YOUR CODE HERE: calculate based on the
  100168:	89 f7                	mov    %esi,%edi
  10016a:	29 d7                	sub    %edx,%edi
				 other variables */;
	dest->p_registers.reg_esp = dest_stack_bottom;
	dest->p_registers.reg_ebp = dest_stack_top;
	// YOUR CODE HERE: memcpy the stack and set dest->p_registers.reg_esp
	memcpy((void *)dest_stack_bottom, (void *)src_stack_bottom,src_stack_top-src_stack_bottom);
  10016c:	29 f2                	sub    %esi,%edx
	// YOUR CODE HERE!

	src_stack_top = PROC1_STACK_ADDR + src->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + dest->p_pid*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	dest_stack_bottom = dest_stack_top + (src_stack_bottom - src_stack_top); /* YOUR CODE HERE: calculate based on the
  10016e:	01 cf                	add    %ecx,%edi
				 other variables */;
	dest->p_registers.reg_esp = dest_stack_bottom;
  100170:	89 78 40             	mov    %edi,0x40(%eax)
	dest->p_registers.reg_ebp = dest_stack_top;
  100173:	89 48 0c             	mov    %ecx,0xc(%eax)
	// YOUR CODE HERE: memcpy the stack and set dest->p_registers.reg_esp
	memcpy((void *)dest_stack_bottom, (void *)src_stack_bottom,src_stack_top-src_stack_bottom);
  100176:	50                   	push   %eax
  100177:	52                   	push   %edx
  100178:	56                   	push   %esi
  100179:	57                   	push   %edi
  10017a:	e8 89 03 00 00       	call   100508 <memcpy>
  10017f:	83 c4 10             	add    $0x10,%esp
		run(current);

	case INT_SYS_FORK:
		// The 'sys_fork' system call should create a new process.
		// You will have to complete the do_fork() function!
		current->p_registers.reg_eax = do_fork(current);
  100182:	89 6b 20             	mov    %ebp,0x20(%ebx)
		run(current);
  100185:	83 ec 0c             	sub    $0xc,%esp
  100188:	ff 35 18 9f 10 00    	pushl  0x109f18
  10018e:	e8 9d 02 00 00       	call   100430 <run>
	case INT_SYS_YIELD:
		// The 'sys_yield' system call asks the kernel to schedule a
		// different process.  (MiniprocOS is cooperatively
		// scheduled, so we need a special system call to do this.)
		// The schedule() function picks another process and runs it.
		schedule();
  100193:	e8 f4 fe ff ff       	call   10008c <schedule>
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  100198:	a1 18 9f 10 00       	mov    0x109f18,%eax
		current->p_exit_status = current->p_registers.reg_eax;

		if(current->queue != NULL){
  10019d:	8b 50 50             	mov    0x50(%eax),%edx
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
		current->p_exit_status = current->p_registers.reg_eax;
  1001a0:	8b 48 20             	mov    0x20(%eax),%ecx
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  1001a3:	c7 40 48 03 00 00 00 	movl   $0x3,0x48(%eax)
		current->p_exit_status = current->p_registers.reg_eax;

		if(current->queue != NULL){
  1001aa:	85 d2                	test   %edx,%edx
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
		current->p_exit_status = current->p_registers.reg_eax;
  1001ac:	89 48 4c             	mov    %ecx,0x4c(%eax)

		if(current->queue != NULL){
  1001af:	74 0a                	je     1001bb <interrupt+0x100>
			current->queue->p_state = P_RUNNABLE;
  1001b1:	c7 42 48 01 00 00 00 	movl   $0x1,0x48(%edx)
			current->queue->p_registers.reg_eax = current->p_exit_status;
  1001b8:	89 4a 20             	mov    %ecx,0x20(%edx)
		}
		current->p_state = P_EMPTY;
  1001bb:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		schedule();
  1001c2:	e8 c5 fe ff ff       	call   10008c <schedule>
		// * A process that doesn't exist (p_state == P_EMPTY).
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
  1001c7:	a1 18 9f 10 00       	mov    0x109f18,%eax
  1001cc:	8b 50 20             	mov    0x20(%eax),%edx
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  1001cf:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1001d2:	83 f9 0e             	cmp    $0xe,%ecx
  1001d5:	77 11                	ja     1001e8 <interrupt+0x12d>
  1001d7:	3b 10                	cmp    (%eax),%edx
  1001d9:	74 0d                	je     1001e8 <interrupt+0x12d>
		    || proc_array[p].p_state == P_EMPTY)
  1001db:	6b d2 54             	imul   $0x54,%edx,%edx
  1001de:	8b 8a b8 91 10 00    	mov    0x1091b8(%edx),%ecx
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  1001e4:	85 c9                	test   %ecx,%ecx
  1001e6:	75 09                	jne    1001f1 <interrupt+0x136>
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
  1001e8:	c7 40 20 ff ff ff ff 	movl   $0xffffffff,0x20(%eax)
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  1001ef:	eb 1d                	jmp    10020e <interrupt+0x153>
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
		else if (proc_array[p].p_state == P_ZOMBIE)
  1001f1:	83 f9 03             	cmp    $0x3,%ecx
  1001f4:	75 0b                	jne    100201 <interrupt+0x146>
			current->p_registers.reg_eax = proc_array[p].p_exit_status;
  1001f6:	8b 92 bc 91 10 00    	mov    0x1091bc(%edx),%edx
  1001fc:	89 50 20             	mov    %edx,0x20(%eax)
  1001ff:	eb 0d                	jmp    10020e <interrupt+0x153>
		else{
			current->p_state  = P_BLOCKED;
  100201:	c7 40 48 02 00 00 00 	movl   $0x2,0x48(%eax)
			proc_array[p].queue = current;
  100208:	89 82 c0 91 10 00    	mov    %eax,0x1091c0(%edx)
		}
		schedule();
  10020e:	e8 79 fe ff ff       	call   10008c <schedule>
  100213:	eb fe                	jmp    100213 <interrupt+0x158>

00100215 <start>:
 *
 *****************************************************************************/

void
start(void)
{
  100215:	53                   	push   %ebx
  100216:	83 ec 0c             	sub    $0xc,%esp
	const char *s;
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
  100219:	68 40 05 00 00       	push   $0x540
  10021e:	6a 00                	push   $0x0
  100220:	68 70 91 10 00       	push   $0x109170
  100225:	e8 42 03 00 00       	call   10056c <memset>
  10022a:	ba 70 91 10 00       	mov    $0x109170,%edx
  10022f:	31 c0                	xor    %eax,%eax
  100231:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  100234:	89 02                	mov    %eax,(%edx)
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  100236:	40                   	inc    %eax
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  100237:	c7 42 48 00 00 00 00 	movl   $0x0,0x48(%edx)
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  10023e:	83 c2 54             	add    $0x54,%edx
  100241:	83 f8 10             	cmp    $0x10,%eax
  100244:	75 ee                	jne    100234 <start+0x1f>
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
	}

	// The first process has process ID 1.
	current = &proc_array[1];
  100246:	c7 05 18 9f 10 00 c4 	movl   $0x1091c4,0x109f18
  10024d:	91 10 00 

	// Set up x86 hardware, and initialize the first process's
	// special registers.  This only needs to be done once, at boot time.
	// All other processes' special registers can be copied from the
	// first process.
	segments_init();
  100250:	e8 73 00 00 00       	call   1002c8 <segments_init>
	special_registers_init(current);
  100255:	83 ec 0c             	sub    $0xc,%esp
  100258:	ff 35 18 9f 10 00    	pushl  0x109f18
  10025e:	e8 e4 01 00 00       	call   100447 <special_registers_init>

	// Erase the console, and initialize the cursor-position shared
	// variable to point to its upper left.
	console_clear();
  100263:	e8 2f 01 00 00       	call   100397 <console_clear>

	// Figure out which program to run.
	cursorpos = console_printf(cursorpos, 0x0700, "Type '1' to run mpos-app, or '2' to run mpos-app2.");
  100268:	83 c4 0c             	add    $0xc,%esp
  10026b:	68 fc 09 10 00       	push   $0x1009fc
  100270:	68 00 07 00 00       	push   $0x700
  100275:	ff 35 00 00 06 00    	pushl  0x60000
  10027b:	e8 4e 07 00 00       	call   1009ce <console_printf>
  100280:	83 c4 10             	add    $0x10,%esp
  100283:	a3 00 00 06 00       	mov    %eax,0x60000
	do {
		whichprocess = console_read_digit();
  100288:	e8 4d 01 00 00       	call   1003da <console_read_digit>
	} while (whichprocess != 1 && whichprocess != 2);
  10028d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100290:	83 fb 01             	cmp    $0x1,%ebx
  100293:	77 f3                	ja     100288 <start+0x73>
	console_clear();
  100295:	e8 fd 00 00 00       	call   100397 <console_clear>

	// Load the process application code and data into memory.
	// Store its entry point into the first process's EIP
	// (instruction pointer).
	program_loader(whichprocess - 1, &current->p_registers.reg_eip);
  10029a:	a1 18 9f 10 00       	mov    0x109f18,%eax
  10029f:	83 c0 34             	add    $0x34,%eax
  1002a2:	52                   	push   %edx
  1002a3:	52                   	push   %edx
  1002a4:	50                   	push   %eax
  1002a5:	53                   	push   %ebx
  1002a6:	e8 d1 01 00 00       	call   10047c <program_loader>

	// Set the main process's stack pointer, ESP.
	current->p_registers.reg_esp = PROC1_STACK_ADDR + PROC_STACK_SIZE;
  1002ab:	a1 18 9f 10 00       	mov    0x109f18,%eax
  1002b0:	c7 40 40 00 00 2c 00 	movl   $0x2c0000,0x40(%eax)

	// Mark the process as runnable!
	current->p_state = P_RUNNABLE;
  1002b7:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%eax)

	// Switch to the main process using run().
	run(current);
  1002be:	89 04 24             	mov    %eax,(%esp)
  1002c1:	e8 6a 01 00 00       	call   100430 <run>
  1002c6:	90                   	nop
  1002c7:	90                   	nop

001002c8 <segments_init>:
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002c8:	b8 b0 96 10 00       	mov    $0x1096b0,%eax
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002cd:	b9 56 00 10 00       	mov    $0x100056,%ecx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002d2:	89 c2                	mov    %eax,%edx
  1002d4:	c1 ea 10             	shr    $0x10,%edx
extern void default_int_handler(void);


void
segments_init(void)
{
  1002d7:	53                   	push   %ebx
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002d8:	bb 56 00 10 00       	mov    $0x100056,%ebx
  1002dd:	c1 eb 10             	shr    $0x10,%ebx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002e0:	66 a3 9a 1a 10 00    	mov    %ax,0x101a9a
  1002e6:	c1 e8 18             	shr    $0x18,%eax
  1002e9:	88 15 9c 1a 10 00    	mov    %dl,0x101a9c
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002ef:	ba 18 97 10 00       	mov    $0x109718,%edx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002f4:	a2 9f 1a 10 00       	mov    %al,0x101a9f
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002f9:	31 c0                	xor    %eax,%eax
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002fb:	66 c7 05 98 1a 10 00 	movw   $0x68,0x101a98
  100302:	68 00 
  100304:	c6 05 9e 1a 10 00 40 	movb   $0x40,0x101a9e
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
			sizeof(taskstate_t), 0);
	segments[SEGSEL_TASKSTATE >> 3].sd_s = 0;
  10030b:	c6 05 9d 1a 10 00 89 	movb   $0x89,0x101a9d

	// Set up kernel task descriptor, so we can receive interrupts
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
  100312:	c7 05 b4 96 10 00 00 	movl   $0x80000,0x1096b4
  100319:	00 08 00 
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;
  10031c:	66 c7 05 b8 96 10 00 	movw   $0x10,0x1096b8
  100323:	10 00 

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100325:	66 89 0c c5 18 97 10 	mov    %cx,0x109718(,%eax,8)
  10032c:	00 
  10032d:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  100334:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  100339:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  10033e:	66 89 5c c2 06       	mov    %bx,0x6(%edx,%eax,8)
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  100343:	40                   	inc    %eax
  100344:	3d 00 01 00 00       	cmp    $0x100,%eax
  100349:	75 da                	jne    100325 <segments_init+0x5d>
  10034b:	66 b8 30 00          	mov    $0x30,%ax

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  10034f:	ba 18 97 10 00       	mov    $0x109718,%edx
  100354:	8b 0c 85 a3 ff 0f 00 	mov    0xfffa3(,%eax,4),%ecx
  10035b:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  100362:	66 89 0c c5 18 97 10 	mov    %cx,0x109718(,%eax,8)
  100369:	00 
  10036a:	c1 e9 10             	shr    $0x10,%ecx
  10036d:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  100372:	c6 44 c2 05 ee       	movb   $0xee,0x5(%edx,%eax,8)
  100377:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
  10037c:	40                   	inc    %eax
  10037d:	83 f8 3a             	cmp    $0x3a,%eax
  100380:	75 d2                	jne    100354 <segments_init+0x8c>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, sys_int_handlers[i - INT_SYS_GETPID], 3);

	// Reload segment pointers
	asm volatile("lgdt global_descriptor_table\n\t"
  100382:	b0 28                	mov    $0x28,%al
  100384:	0f 01 15 60 1a 10 00 	lgdtl  0x101a60
  10038b:	0f 00 d8             	ltr    %ax
  10038e:	0f 01 1d 68 1a 10 00 	lidtl  0x101a68
		     "lidt interrupt_descriptor_table"
		     : : "r" ((uint16_t) SEGSEL_TASKSTATE));

	// Convince compiler that all symbols were used
	(void) global_descriptor_table, (void) interrupt_descriptor_table;
}
  100395:	5b                   	pop    %ebx
  100396:	c3                   	ret    

00100397 <console_clear>:
 *
 *****************************************************************************/

void
console_clear(void)
{
  100397:	56                   	push   %esi
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  100398:	31 c0                	xor    %eax,%eax
 *
 *****************************************************************************/

void
console_clear(void)
{
  10039a:	53                   	push   %ebx
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  10039b:	c7 05 00 00 06 00 00 	movl   $0xb8000,0x60000
  1003a2:	80 0b 00 

	for (i = 0; i < 80 * 25; i++)
		cursorpos[i] = ' ' | 0x0700;
  1003a5:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%eax,%eax,1)
  1003ac:	00 20 07 
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;

	for (i = 0; i < 80 * 25; i++)
  1003af:	40                   	inc    %eax
  1003b0:	3d d0 07 00 00       	cmp    $0x7d0,%eax
  1003b5:	75 ee                	jne    1003a5 <console_clear+0xe>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1003b7:	be d4 03 00 00       	mov    $0x3d4,%esi
  1003bc:	b0 0e                	mov    $0xe,%al
  1003be:	89 f2                	mov    %esi,%edx
  1003c0:	ee                   	out    %al,(%dx)
  1003c1:	31 c9                	xor    %ecx,%ecx
  1003c3:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  1003c8:	88 c8                	mov    %cl,%al
  1003ca:	89 da                	mov    %ebx,%edx
  1003cc:	ee                   	out    %al,(%dx)
  1003cd:	b0 0f                	mov    $0xf,%al
  1003cf:	89 f2                	mov    %esi,%edx
  1003d1:	ee                   	out    %al,(%dx)
  1003d2:	88 c8                	mov    %cl,%al
  1003d4:	89 da                	mov    %ebx,%edx
  1003d6:	ee                   	out    %al,(%dx)
		cursorpos[i] = ' ' | 0x0700;
	outb(0x3D4, 14);
	outb(0x3D5, 0 / 256);
	outb(0x3D4, 15);
	outb(0x3D5, 0 % 256);
}
  1003d7:	5b                   	pop    %ebx
  1003d8:	5e                   	pop    %esi
  1003d9:	c3                   	ret    

001003da <console_read_digit>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  1003da:	ba 64 00 00 00       	mov    $0x64,%edx
  1003df:	ec                   	in     (%dx),%al
int
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  1003e0:	a8 01                	test   $0x1,%al
  1003e2:	74 45                	je     100429 <console_read_digit+0x4f>
  1003e4:	b2 60                	mov    $0x60,%dl
  1003e6:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
  1003e7:	8d 50 fe             	lea    -0x2(%eax),%edx
  1003ea:	80 fa 08             	cmp    $0x8,%dl
  1003ed:	77 05                	ja     1003f4 <console_read_digit+0x1a>
		return data - 0x02 + 1;
  1003ef:	0f b6 c0             	movzbl %al,%eax
  1003f2:	48                   	dec    %eax
  1003f3:	c3                   	ret    
	else if (data == 0x0B)
  1003f4:	3c 0b                	cmp    $0xb,%al
  1003f6:	74 35                	je     10042d <console_read_digit+0x53>
		return 0;
	else if (data >= 0x47 && data <= 0x49)
  1003f8:	8d 50 b9             	lea    -0x47(%eax),%edx
  1003fb:	80 fa 02             	cmp    $0x2,%dl
  1003fe:	77 07                	ja     100407 <console_read_digit+0x2d>
		return data - 0x47 + 7;
  100400:	0f b6 c0             	movzbl %al,%eax
  100403:	83 e8 40             	sub    $0x40,%eax
  100406:	c3                   	ret    
	else if (data >= 0x4B && data <= 0x4D)
  100407:	8d 50 b5             	lea    -0x4b(%eax),%edx
  10040a:	80 fa 02             	cmp    $0x2,%dl
  10040d:	77 07                	ja     100416 <console_read_digit+0x3c>
		return data - 0x4B + 4;
  10040f:	0f b6 c0             	movzbl %al,%eax
  100412:	83 e8 47             	sub    $0x47,%eax
  100415:	c3                   	ret    
	else if (data >= 0x4F && data <= 0x51)
  100416:	8d 50 b1             	lea    -0x4f(%eax),%edx
  100419:	80 fa 02             	cmp    $0x2,%dl
  10041c:	77 07                	ja     100425 <console_read_digit+0x4b>
		return data - 0x4F + 1;
  10041e:	0f b6 c0             	movzbl %al,%eax
  100421:	83 e8 4e             	sub    $0x4e,%eax
  100424:	c3                   	ret    
	else if (data == 0x53)
  100425:	3c 53                	cmp    $0x53,%al
  100427:	74 04                	je     10042d <console_read_digit+0x53>
  100429:	83 c8 ff             	or     $0xffffffff,%eax
  10042c:	c3                   	ret    
  10042d:	31 c0                	xor    %eax,%eax
		return 0;
	else
		return -1;
}
  10042f:	c3                   	ret    

00100430 <run>:
 *
 *****************************************************************************/

void
run(process_t *proc)
{
  100430:	8b 44 24 04          	mov    0x4(%esp),%eax
	current = proc;
  100434:	a3 18 9f 10 00       	mov    %eax,0x109f18

	asm volatile("movl %0,%%esp\n\t"
  100439:	83 c0 04             	add    $0x4,%eax
  10043c:	89 c4                	mov    %eax,%esp
  10043e:	61                   	popa   
  10043f:	07                   	pop    %es
  100440:	1f                   	pop    %ds
  100441:	83 c4 08             	add    $0x8,%esp
  100444:	cf                   	iret   
  100445:	eb fe                	jmp    100445 <run+0x15>

00100447 <special_registers_init>:
 *
 *****************************************************************************/

void
special_registers_init(process_t *proc)
{
  100447:	53                   	push   %ebx
  100448:	83 ec 0c             	sub    $0xc,%esp
  10044b:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	memset(&proc->p_registers, 0, sizeof(registers_t));
  10044f:	6a 44                	push   $0x44
  100451:	6a 00                	push   $0x0
  100453:	8d 43 04             	lea    0x4(%ebx),%eax
  100456:	50                   	push   %eax
  100457:	e8 10 01 00 00       	call   10056c <memset>
	proc->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
  10045c:	66 c7 43 38 1b 00    	movw   $0x1b,0x38(%ebx)
	proc->p_registers.reg_ds = SEGSEL_APP_DATA | 3;
  100462:	66 c7 43 28 23 00    	movw   $0x23,0x28(%ebx)
	proc->p_registers.reg_es = SEGSEL_APP_DATA | 3;
  100468:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	proc->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
  10046e:	66 c7 43 44 23 00    	movw   $0x23,0x44(%ebx)
}
  100474:	83 c4 18             	add    $0x18,%esp
  100477:	5b                   	pop    %ebx
  100478:	c3                   	ret    
  100479:	90                   	nop
  10047a:	90                   	nop
  10047b:	90                   	nop

0010047c <program_loader>:
		    uint32_t filesz, uint32_t memsz);
static void loader_panic(void);

void
program_loader(int program_id, uint32_t *entry_point)
{
  10047c:	55                   	push   %ebp
  10047d:	57                   	push   %edi
  10047e:	56                   	push   %esi
  10047f:	53                   	push   %ebx
  100480:	83 ec 1c             	sub    $0x1c,%esp
  100483:	8b 44 24 30          	mov    0x30(%esp),%eax
	struct Proghdr *ph, *eph;
	struct Elf *elf_header;
	int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);

	if (program_id < 0 || program_id >= nprograms)
  100487:	83 f8 01             	cmp    $0x1,%eax
  10048a:	7f 04                	jg     100490 <program_loader+0x14>
  10048c:	85 c0                	test   %eax,%eax
  10048e:	79 02                	jns    100492 <program_loader+0x16>
  100490:	eb fe                	jmp    100490 <program_loader+0x14>
		loader_panic();

	// is this a valid ELF?
	elf_header = (struct Elf *) ramimages[program_id].begin;
  100492:	8b 34 c5 a0 1a 10 00 	mov    0x101aa0(,%eax,8),%esi
	if (elf_header->e_magic != ELF_MAGIC)
  100499:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  10049f:	74 02                	je     1004a3 <program_loader+0x27>
  1004a1:	eb fe                	jmp    1004a1 <program_loader+0x25>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1004a3:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	eph = ph + elf_header->e_phnum;
  1004a6:	0f b7 6e 2c          	movzwl 0x2c(%esi),%ebp
	elf_header = (struct Elf *) ramimages[program_id].begin;
	if (elf_header->e_magic != ELF_MAGIC)
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1004aa:	01 f3                	add    %esi,%ebx
	eph = ph + elf_header->e_phnum;
  1004ac:	c1 e5 05             	shl    $0x5,%ebp
  1004af:	8d 2c 2b             	lea    (%ebx,%ebp,1),%ebp
	for (; ph < eph; ph++)
  1004b2:	eb 3f                	jmp    1004f3 <program_loader+0x77>
		if (ph->p_type == ELF_PROG_LOAD)
  1004b4:	83 3b 01             	cmpl   $0x1,(%ebx)
  1004b7:	75 37                	jne    1004f0 <program_loader+0x74>
			copyseg((void *) ph->p_va,
  1004b9:	8b 43 08             	mov    0x8(%ebx),%eax
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  1004bc:	8b 7b 10             	mov    0x10(%ebx),%edi
	memsz += va;
  1004bf:	8b 53 14             	mov    0x14(%ebx),%edx
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  1004c2:	01 c7                	add    %eax,%edi
	memsz += va;
  1004c4:	01 c2                	add    %eax,%edx
	va &= ~(PAGESIZE - 1);		// round to page boundary
  1004c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
	memsz += va;
  1004cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  1004cf:	52                   	push   %edx
  1004d0:	89 fa                	mov    %edi,%edx
  1004d2:	29 c2                	sub    %eax,%edx
  1004d4:	52                   	push   %edx
  1004d5:	8b 53 04             	mov    0x4(%ebx),%edx
  1004d8:	01 f2                	add    %esi,%edx
  1004da:	52                   	push   %edx
  1004db:	50                   	push   %eax
  1004dc:	e8 27 00 00 00       	call   100508 <memcpy>
  1004e1:	83 c4 10             	add    $0x10,%esp
  1004e4:	eb 04                	jmp    1004ea <program_loader+0x6e>

	// clear bss segment
	while (end_va < memsz)
		*((uint8_t *) end_va++) = 0;
  1004e6:	c6 07 00             	movb   $0x0,(%edi)
  1004e9:	47                   	inc    %edi

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);

	// clear bss segment
	while (end_va < memsz)
  1004ea:	3b 7c 24 0c          	cmp    0xc(%esp),%edi
  1004ee:	72 f6                	jb     1004e6 <program_loader+0x6a>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
  1004f0:	83 c3 20             	add    $0x20,%ebx
  1004f3:	39 eb                	cmp    %ebp,%ebx
  1004f5:	72 bd                	jb     1004b4 <program_loader+0x38>
			copyseg((void *) ph->p_va,
				(const uint8_t *) elf_header + ph->p_offset,
				ph->p_filesz, ph->p_memsz);

	// store the entry point from the ELF header
	*entry_point = elf_header->e_entry;
  1004f7:	8b 56 18             	mov    0x18(%esi),%edx
  1004fa:	8b 44 24 34          	mov    0x34(%esp),%eax
  1004fe:	89 10                	mov    %edx,(%eax)
}
  100500:	83 c4 1c             	add    $0x1c,%esp
  100503:	5b                   	pop    %ebx
  100504:	5e                   	pop    %esi
  100505:	5f                   	pop    %edi
  100506:	5d                   	pop    %ebp
  100507:	c3                   	ret    

00100508 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  100508:	56                   	push   %esi
  100509:	31 d2                	xor    %edx,%edx
  10050b:	53                   	push   %ebx
  10050c:	8b 44 24 0c          	mov    0xc(%esp),%eax
  100510:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  100514:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100518:	eb 08                	jmp    100522 <memcpy+0x1a>
		*d++ = *s++;
  10051a:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  10051d:	4e                   	dec    %esi
  10051e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  100521:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100522:	85 f6                	test   %esi,%esi
  100524:	75 f4                	jne    10051a <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  100526:	5b                   	pop    %ebx
  100527:	5e                   	pop    %esi
  100528:	c3                   	ret    

00100529 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  100529:	57                   	push   %edi
  10052a:	56                   	push   %esi
  10052b:	53                   	push   %ebx
  10052c:	8b 44 24 10          	mov    0x10(%esp),%eax
  100530:	8b 7c 24 14          	mov    0x14(%esp),%edi
  100534:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  100538:	39 c7                	cmp    %eax,%edi
  10053a:	73 26                	jae    100562 <memmove+0x39>
  10053c:	8d 34 17             	lea    (%edi,%edx,1),%esi
  10053f:	39 c6                	cmp    %eax,%esi
  100541:	76 1f                	jbe    100562 <memmove+0x39>
		s += n, d += n;
  100543:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  100546:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  100548:	eb 07                	jmp    100551 <memmove+0x28>
			*--d = *--s;
  10054a:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  10054d:	4a                   	dec    %edx
  10054e:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  100551:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  100552:	85 d2                	test   %edx,%edx
  100554:	75 f4                	jne    10054a <memmove+0x21>
  100556:	eb 10                	jmp    100568 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  100558:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  10055b:	4a                   	dec    %edx
  10055c:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  10055f:	41                   	inc    %ecx
  100560:	eb 02                	jmp    100564 <memmove+0x3b>
  100562:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  100564:	85 d2                	test   %edx,%edx
  100566:	75 f0                	jne    100558 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  100568:	5b                   	pop    %ebx
  100569:	5e                   	pop    %esi
  10056a:	5f                   	pop    %edi
  10056b:	c3                   	ret    

0010056c <memset>:

void *
memset(void *v, int c, size_t n)
{
  10056c:	53                   	push   %ebx
  10056d:	8b 44 24 08          	mov    0x8(%esp),%eax
  100571:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  100575:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  100579:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  10057b:	eb 04                	jmp    100581 <memset+0x15>
		*p++ = c;
  10057d:	88 1a                	mov    %bl,(%edx)
  10057f:	49                   	dec    %ecx
  100580:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  100581:	85 c9                	test   %ecx,%ecx
  100583:	75 f8                	jne    10057d <memset+0x11>
		*p++ = c;
	return v;
}
  100585:	5b                   	pop    %ebx
  100586:	c3                   	ret    

00100587 <strlen>:

size_t
strlen(const char *s)
{
  100587:	8b 54 24 04          	mov    0x4(%esp),%edx
  10058b:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  10058d:	eb 01                	jmp    100590 <strlen+0x9>
		++n;
  10058f:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  100590:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100594:	75 f9                	jne    10058f <strlen+0x8>
		++n;
	return n;
}
  100596:	c3                   	ret    

00100597 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  100597:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10059b:	31 c0                	xor    %eax,%eax
  10059d:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1005a1:	eb 01                	jmp    1005a4 <strnlen+0xd>
		++n;
  1005a3:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1005a4:	39 d0                	cmp    %edx,%eax
  1005a6:	74 06                	je     1005ae <strnlen+0x17>
  1005a8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  1005ac:	75 f5                	jne    1005a3 <strnlen+0xc>
		++n;
	return n;
}
  1005ae:	c3                   	ret    

001005af <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1005af:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  1005b0:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1005b5:	53                   	push   %ebx
  1005b6:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  1005b8:	76 05                	jbe    1005bf <console_putc+0x10>
  1005ba:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  1005bf:	80 fa 0a             	cmp    $0xa,%dl
  1005c2:	75 2c                	jne    1005f0 <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  1005c4:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  1005ca:	be 50 00 00 00       	mov    $0x50,%esi
  1005cf:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  1005d1:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  1005d4:	99                   	cltd   
  1005d5:	f7 fe                	idiv   %esi
  1005d7:	89 de                	mov    %ebx,%esi
  1005d9:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  1005db:	eb 07                	jmp    1005e4 <console_putc+0x35>
			*cursor++ = ' ' | color;
  1005dd:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  1005e0:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  1005e1:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  1005e4:	83 f8 50             	cmp    $0x50,%eax
  1005e7:	75 f4                	jne    1005dd <console_putc+0x2e>
  1005e9:	29 d0                	sub    %edx,%eax
  1005eb:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  1005ee:	eb 0b                	jmp    1005fb <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1005f0:	0f b6 d2             	movzbl %dl,%edx
  1005f3:	09 ca                	or     %ecx,%edx
  1005f5:	66 89 13             	mov    %dx,(%ebx)
  1005f8:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  1005fb:	5b                   	pop    %ebx
  1005fc:	5e                   	pop    %esi
  1005fd:	c3                   	ret    

001005fe <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  1005fe:	56                   	push   %esi
  1005ff:	53                   	push   %ebx
  100600:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  100604:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100607:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  10060b:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  100610:	75 04                	jne    100616 <fill_numbuf+0x18>
  100612:	85 d2                	test   %edx,%edx
  100614:	74 10                	je     100626 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  100616:	89 d0                	mov    %edx,%eax
  100618:	31 d2                	xor    %edx,%edx
  10061a:	f7 f1                	div    %ecx
  10061c:	4b                   	dec    %ebx
  10061d:	8a 14 16             	mov    (%esi,%edx,1),%dl
  100620:	88 13                	mov    %dl,(%ebx)
			val /= base;
  100622:	89 c2                	mov    %eax,%edx
  100624:	eb ec                	jmp    100612 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  100626:	89 d8                	mov    %ebx,%eax
  100628:	5b                   	pop    %ebx
  100629:	5e                   	pop    %esi
  10062a:	c3                   	ret    

0010062b <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  10062b:	55                   	push   %ebp
  10062c:	57                   	push   %edi
  10062d:	56                   	push   %esi
  10062e:	53                   	push   %ebx
  10062f:	83 ec 38             	sub    $0x38,%esp
  100632:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  100636:	8b 7c 24 54          	mov    0x54(%esp),%edi
  10063a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  10063e:	e9 60 03 00 00       	jmp    1009a3 <console_vprintf+0x378>
		if (*format != '%') {
  100643:	80 fa 25             	cmp    $0x25,%dl
  100646:	74 13                	je     10065b <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  100648:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  10064c:	0f b6 d2             	movzbl %dl,%edx
  10064f:	89 f0                	mov    %esi,%eax
  100651:	e8 59 ff ff ff       	call   1005af <console_putc>
  100656:	e9 45 03 00 00       	jmp    1009a0 <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  10065b:	47                   	inc    %edi
  10065c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  100663:	00 
  100664:	eb 12                	jmp    100678 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  100666:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  100667:	8a 11                	mov    (%ecx),%dl
  100669:	84 d2                	test   %dl,%dl
  10066b:	74 1a                	je     100687 <console_vprintf+0x5c>
  10066d:	89 e8                	mov    %ebp,%eax
  10066f:	38 c2                	cmp    %al,%dl
  100671:	75 f3                	jne    100666 <console_vprintf+0x3b>
  100673:	e9 3f 03 00 00       	jmp    1009b7 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100678:	8a 17                	mov    (%edi),%dl
  10067a:	84 d2                	test   %dl,%dl
  10067c:	74 0b                	je     100689 <console_vprintf+0x5e>
  10067e:	b9 30 0a 10 00       	mov    $0x100a30,%ecx
  100683:	89 d5                	mov    %edx,%ebp
  100685:	eb e0                	jmp    100667 <console_vprintf+0x3c>
  100687:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  100689:	8d 42 cf             	lea    -0x31(%edx),%eax
  10068c:	3c 08                	cmp    $0x8,%al
  10068e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100695:	00 
  100696:	76 13                	jbe    1006ab <console_vprintf+0x80>
  100698:	eb 1d                	jmp    1006b7 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  10069a:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  10069f:	0f be c0             	movsbl %al,%eax
  1006a2:	47                   	inc    %edi
  1006a3:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  1006a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  1006ab:	8a 07                	mov    (%edi),%al
  1006ad:	8d 50 d0             	lea    -0x30(%eax),%edx
  1006b0:	80 fa 09             	cmp    $0x9,%dl
  1006b3:	76 e5                	jbe    10069a <console_vprintf+0x6f>
  1006b5:	eb 18                	jmp    1006cf <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  1006b7:	80 fa 2a             	cmp    $0x2a,%dl
  1006ba:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  1006c1:	ff 
  1006c2:	75 0b                	jne    1006cf <console_vprintf+0xa4>
			width = va_arg(val, int);
  1006c4:	83 c3 04             	add    $0x4,%ebx
			++format;
  1006c7:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  1006c8:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1006cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  1006cf:	83 cd ff             	or     $0xffffffff,%ebp
  1006d2:	80 3f 2e             	cmpb   $0x2e,(%edi)
  1006d5:	75 37                	jne    10070e <console_vprintf+0xe3>
			++format;
  1006d7:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  1006d8:	31 ed                	xor    %ebp,%ebp
  1006da:	8a 07                	mov    (%edi),%al
  1006dc:	8d 50 d0             	lea    -0x30(%eax),%edx
  1006df:	80 fa 09             	cmp    $0x9,%dl
  1006e2:	76 0d                	jbe    1006f1 <console_vprintf+0xc6>
  1006e4:	eb 17                	jmp    1006fd <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  1006e6:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  1006e9:	0f be c0             	movsbl %al,%eax
  1006ec:	47                   	inc    %edi
  1006ed:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  1006f1:	8a 07                	mov    (%edi),%al
  1006f3:	8d 50 d0             	lea    -0x30(%eax),%edx
  1006f6:	80 fa 09             	cmp    $0x9,%dl
  1006f9:	76 eb                	jbe    1006e6 <console_vprintf+0xbb>
  1006fb:	eb 11                	jmp    10070e <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  1006fd:	3c 2a                	cmp    $0x2a,%al
  1006ff:	75 0b                	jne    10070c <console_vprintf+0xe1>
				precision = va_arg(val, int);
  100701:	83 c3 04             	add    $0x4,%ebx
				++format;
  100704:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  100705:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  100708:	85 ed                	test   %ebp,%ebp
  10070a:	79 02                	jns    10070e <console_vprintf+0xe3>
  10070c:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  10070e:	8a 07                	mov    (%edi),%al
  100710:	3c 64                	cmp    $0x64,%al
  100712:	74 34                	je     100748 <console_vprintf+0x11d>
  100714:	7f 1d                	jg     100733 <console_vprintf+0x108>
  100716:	3c 58                	cmp    $0x58,%al
  100718:	0f 84 a2 00 00 00    	je     1007c0 <console_vprintf+0x195>
  10071e:	3c 63                	cmp    $0x63,%al
  100720:	0f 84 bf 00 00 00    	je     1007e5 <console_vprintf+0x1ba>
  100726:	3c 43                	cmp    $0x43,%al
  100728:	0f 85 d0 00 00 00    	jne    1007fe <console_vprintf+0x1d3>
  10072e:	e9 a3 00 00 00       	jmp    1007d6 <console_vprintf+0x1ab>
  100733:	3c 75                	cmp    $0x75,%al
  100735:	74 4d                	je     100784 <console_vprintf+0x159>
  100737:	3c 78                	cmp    $0x78,%al
  100739:	74 5c                	je     100797 <console_vprintf+0x16c>
  10073b:	3c 73                	cmp    $0x73,%al
  10073d:	0f 85 bb 00 00 00    	jne    1007fe <console_vprintf+0x1d3>
  100743:	e9 86 00 00 00       	jmp    1007ce <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  100748:	83 c3 04             	add    $0x4,%ebx
  10074b:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  10074e:	89 d1                	mov    %edx,%ecx
  100750:	c1 f9 1f             	sar    $0x1f,%ecx
  100753:	89 0c 24             	mov    %ecx,(%esp)
  100756:	31 ca                	xor    %ecx,%edx
  100758:	55                   	push   %ebp
  100759:	29 ca                	sub    %ecx,%edx
  10075b:	68 38 0a 10 00       	push   $0x100a38
  100760:	b9 0a 00 00 00       	mov    $0xa,%ecx
  100765:	8d 44 24 40          	lea    0x40(%esp),%eax
  100769:	e8 90 fe ff ff       	call   1005fe <fill_numbuf>
  10076e:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  100772:	58                   	pop    %eax
  100773:	5a                   	pop    %edx
  100774:	ba 01 00 00 00       	mov    $0x1,%edx
  100779:	8b 04 24             	mov    (%esp),%eax
  10077c:	83 e0 01             	and    $0x1,%eax
  10077f:	e9 a5 00 00 00       	jmp    100829 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  100784:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  100787:	b9 0a 00 00 00       	mov    $0xa,%ecx
  10078c:	8b 53 fc             	mov    -0x4(%ebx),%edx
  10078f:	55                   	push   %ebp
  100790:	68 38 0a 10 00       	push   $0x100a38
  100795:	eb 11                	jmp    1007a8 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  100797:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  10079a:	8b 53 fc             	mov    -0x4(%ebx),%edx
  10079d:	55                   	push   %ebp
  10079e:	68 4c 0a 10 00       	push   $0x100a4c
  1007a3:	b9 10 00 00 00       	mov    $0x10,%ecx
  1007a8:	8d 44 24 40          	lea    0x40(%esp),%eax
  1007ac:	e8 4d fe ff ff       	call   1005fe <fill_numbuf>
  1007b1:	ba 01 00 00 00       	mov    $0x1,%edx
  1007b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1007ba:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  1007bc:	59                   	pop    %ecx
  1007bd:	59                   	pop    %ecx
  1007be:	eb 69                	jmp    100829 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  1007c0:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  1007c3:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007c6:	55                   	push   %ebp
  1007c7:	68 38 0a 10 00       	push   $0x100a38
  1007cc:	eb d5                	jmp    1007a3 <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  1007ce:	83 c3 04             	add    $0x4,%ebx
  1007d1:	8b 43 fc             	mov    -0x4(%ebx),%eax
  1007d4:	eb 40                	jmp    100816 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  1007d6:	83 c3 04             	add    $0x4,%ebx
  1007d9:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007dc:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  1007e0:	e9 bd 01 00 00       	jmp    1009a2 <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  1007e5:	83 c3 04             	add    $0x4,%ebx
  1007e8:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  1007eb:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  1007ef:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  1007f4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  1007f8:	88 44 24 24          	mov    %al,0x24(%esp)
  1007fc:	eb 27                	jmp    100825 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  1007fe:	84 c0                	test   %al,%al
  100800:	75 02                	jne    100804 <console_vprintf+0x1d9>
  100802:	b0 25                	mov    $0x25,%al
  100804:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  100808:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  10080d:	80 3f 00             	cmpb   $0x0,(%edi)
  100810:	74 0a                	je     10081c <console_vprintf+0x1f1>
  100812:	8d 44 24 24          	lea    0x24(%esp),%eax
  100816:	89 44 24 04          	mov    %eax,0x4(%esp)
  10081a:	eb 09                	jmp    100825 <console_vprintf+0x1fa>
				format--;
  10081c:	8d 54 24 24          	lea    0x24(%esp),%edx
  100820:	4f                   	dec    %edi
  100821:	89 54 24 04          	mov    %edx,0x4(%esp)
  100825:	31 d2                	xor    %edx,%edx
  100827:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  100829:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  10082b:	83 fd ff             	cmp    $0xffffffff,%ebp
  10082e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100835:	74 1f                	je     100856 <console_vprintf+0x22b>
  100837:	89 04 24             	mov    %eax,(%esp)
  10083a:	eb 01                	jmp    10083d <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  10083c:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  10083d:	39 e9                	cmp    %ebp,%ecx
  10083f:	74 0a                	je     10084b <console_vprintf+0x220>
  100841:	8b 44 24 04          	mov    0x4(%esp),%eax
  100845:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  100849:	75 f1                	jne    10083c <console_vprintf+0x211>
  10084b:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  10084e:	89 0c 24             	mov    %ecx,(%esp)
  100851:	eb 1f                	jmp    100872 <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  100853:	42                   	inc    %edx
  100854:	eb 09                	jmp    10085f <console_vprintf+0x234>
  100856:	89 d1                	mov    %edx,%ecx
  100858:	8b 14 24             	mov    (%esp),%edx
  10085b:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  10085f:	8b 44 24 04          	mov    0x4(%esp),%eax
  100863:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  100867:	75 ea                	jne    100853 <console_vprintf+0x228>
  100869:	8b 44 24 08          	mov    0x8(%esp),%eax
  10086d:	89 14 24             	mov    %edx,(%esp)
  100870:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  100872:	85 c0                	test   %eax,%eax
  100874:	74 0c                	je     100882 <console_vprintf+0x257>
  100876:	84 d2                	test   %dl,%dl
  100878:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  10087f:	00 
  100880:	75 24                	jne    1008a6 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  100882:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  100887:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  10088e:	00 
  10088f:	75 15                	jne    1008a6 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  100891:	8b 44 24 14          	mov    0x14(%esp),%eax
  100895:	83 e0 08             	and    $0x8,%eax
  100898:	83 f8 01             	cmp    $0x1,%eax
  10089b:	19 c9                	sbb    %ecx,%ecx
  10089d:	f7 d1                	not    %ecx
  10089f:	83 e1 20             	and    $0x20,%ecx
  1008a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  1008a6:	3b 2c 24             	cmp    (%esp),%ebp
  1008a9:	7e 0d                	jle    1008b8 <console_vprintf+0x28d>
  1008ab:	84 d2                	test   %dl,%dl
  1008ad:	74 40                	je     1008ef <console_vprintf+0x2c4>
			zeros = precision - len;
  1008af:	2b 2c 24             	sub    (%esp),%ebp
  1008b2:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  1008b6:	eb 3f                	jmp    1008f7 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008b8:	84 d2                	test   %dl,%dl
  1008ba:	74 33                	je     1008ef <console_vprintf+0x2c4>
  1008bc:	8b 44 24 14          	mov    0x14(%esp),%eax
  1008c0:	83 e0 06             	and    $0x6,%eax
  1008c3:	83 f8 02             	cmp    $0x2,%eax
  1008c6:	75 27                	jne    1008ef <console_vprintf+0x2c4>
  1008c8:	45                   	inc    %ebp
  1008c9:	75 24                	jne    1008ef <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  1008cb:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008cd:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  1008d0:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  1008d5:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008d8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  1008db:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  1008df:	7d 0e                	jge    1008ef <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  1008e1:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1008e5:	29 ca                	sub    %ecx,%edx
  1008e7:	29 c2                	sub    %eax,%edx
  1008e9:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008ed:	eb 08                	jmp    1008f7 <console_vprintf+0x2cc>
  1008ef:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  1008f6:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  1008f7:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  1008fb:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  1008fd:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100901:	2b 2c 24             	sub    (%esp),%ebp
  100904:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100909:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10090c:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  10090f:	29 c5                	sub    %eax,%ebp
  100911:	89 f0                	mov    %esi,%eax
  100913:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100917:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10091b:	eb 0f                	jmp    10092c <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  10091d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100921:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100926:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100927:	e8 83 fc ff ff       	call   1005af <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10092c:	85 ed                	test   %ebp,%ebp
  10092e:	7e 07                	jle    100937 <console_vprintf+0x30c>
  100930:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  100935:	74 e6                	je     10091d <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  100937:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  10093c:	89 c6                	mov    %eax,%esi
  10093e:	74 23                	je     100963 <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  100940:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  100945:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100949:	e8 61 fc ff ff       	call   1005af <console_putc>
  10094e:	89 c6                	mov    %eax,%esi
  100950:	eb 11                	jmp    100963 <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  100952:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100956:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  10095b:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  10095c:	e8 4e fc ff ff       	call   1005af <console_putc>
  100961:	eb 06                	jmp    100969 <console_vprintf+0x33e>
  100963:	89 f0                	mov    %esi,%eax
  100965:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  100969:	85 f6                	test   %esi,%esi
  10096b:	7f e5                	jg     100952 <console_vprintf+0x327>
  10096d:	8b 34 24             	mov    (%esp),%esi
  100970:	eb 15                	jmp    100987 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  100972:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100976:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  100977:	0f b6 11             	movzbl (%ecx),%edx
  10097a:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  10097e:	e8 2c fc ff ff       	call   1005af <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100983:	ff 44 24 04          	incl   0x4(%esp)
  100987:	85 f6                	test   %esi,%esi
  100989:	7f e7                	jg     100972 <console_vprintf+0x347>
  10098b:	eb 0f                	jmp    10099c <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  10098d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100991:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100996:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100997:	e8 13 fc ff ff       	call   1005af <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  10099c:	85 ed                	test   %ebp,%ebp
  10099e:	7f ed                	jg     10098d <console_vprintf+0x362>
  1009a0:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  1009a2:	47                   	inc    %edi
  1009a3:	8a 17                	mov    (%edi),%dl
  1009a5:	84 d2                	test   %dl,%dl
  1009a7:	0f 85 96 fc ff ff    	jne    100643 <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  1009ad:	83 c4 38             	add    $0x38,%esp
  1009b0:	89 f0                	mov    %esi,%eax
  1009b2:	5b                   	pop    %ebx
  1009b3:	5e                   	pop    %esi
  1009b4:	5f                   	pop    %edi
  1009b5:	5d                   	pop    %ebp
  1009b6:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  1009b7:	81 e9 30 0a 10 00    	sub    $0x100a30,%ecx
  1009bd:	b8 01 00 00 00       	mov    $0x1,%eax
  1009c2:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  1009c4:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  1009c5:	09 44 24 14          	or     %eax,0x14(%esp)
  1009c9:	e9 aa fc ff ff       	jmp    100678 <console_vprintf+0x4d>

001009ce <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  1009ce:	8d 44 24 10          	lea    0x10(%esp),%eax
  1009d2:	50                   	push   %eax
  1009d3:	ff 74 24 10          	pushl  0x10(%esp)
  1009d7:	ff 74 24 10          	pushl  0x10(%esp)
  1009db:	ff 74 24 10          	pushl  0x10(%esp)
  1009df:	e8 47 fc ff ff       	call   10062b <console_vprintf>
  1009e4:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  1009e7:	c3                   	ret    

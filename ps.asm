
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
    ps();
   6:	e8 08 03 00 00       	call   313 <ps>
    exit();
   b:	e8 63 02 00 00       	call   273 <exit>

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  10:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  11:	31 c0                	xor    %eax,%eax
{
  13:	89 e5                	mov    %esp,%ebp
  15:	53                   	push   %ebx
  16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  20:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  24:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  27:	40                   	inc    %eax
  28:	84 d2                	test   %dl,%dl
  2a:	75 f4                	jne    20 <strcpy+0x10>
    ;
  return os;
}
  2c:	5b                   	pop    %ebx
  2d:	89 c8                	mov    %ecx,%eax
  2f:	5d                   	pop    %ebp
  30:	c3                   	ret    
  31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3f:	90                   	nop

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
  44:	8b 5d 08             	mov    0x8(%ebp),%ebx
  47:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  4a:	0f b6 03             	movzbl (%ebx),%eax
  4d:	0f b6 0a             	movzbl (%edx),%ecx
  50:	84 c0                	test   %al,%al
  52:	75 19                	jne    6d <strcmp+0x2d>
  54:	eb 2a                	jmp    80 <strcmp+0x40>
  56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5d:	8d 76 00             	lea    0x0(%esi),%esi
  60:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
  64:	43                   	inc    %ebx
  65:	42                   	inc    %edx
  while(*p && *p == *q)
  66:	0f b6 0a             	movzbl (%edx),%ecx
  69:	84 c0                	test   %al,%al
  6b:	74 13                	je     80 <strcmp+0x40>
  6d:	38 c8                	cmp    %cl,%al
  6f:	74 ef                	je     60 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  71:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  72:	29 c8                	sub    %ecx,%eax
}
  74:	5d                   	pop    %ebp
  75:	c3                   	ret    
  76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7d:	8d 76 00             	lea    0x0(%esi),%esi
  80:	5b                   	pop    %ebx
  81:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  83:	29 c8                	sub    %ecx,%eax
}
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    
  87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8e:	66 90                	xchg   %ax,%ax

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 3a 00             	cmpb   $0x0,(%edx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 c0                	xor    %eax,%eax
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	40                   	inc    %eax
  a1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a5:	89 c1                	mov    %eax,%ecx
  a7:	75 f7                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  a9:	5d                   	pop    %ebp
  aa:	89 c8                	mov    %ecx,%eax
  ac:	c3                   	ret    
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  b0:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
  b1:	31 c9                	xor    %ecx,%ecx
}
  b3:	89 c8                	mov    %ecx,%eax
  b5:	c3                   	ret    
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	5f                   	pop    %edi
  d3:	89 d0                	mov    %edx,%eax
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  de:	66 90                	xchg   %ax,%ax

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ea:	0f b6 10             	movzbl (%eax),%edx
  ed:	84 d2                	test   %dl,%dl
  ef:	75 18                	jne    109 <strchr+0x29>
  f1:	eb 1d                	jmp    110 <strchr+0x30>
  f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 100:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 104:	40                   	inc    %eax
 105:	84 d2                	test   %dl,%dl
 107:	74 07                	je     110 <strchr+0x30>
    if(*s == c)
 109:	38 d1                	cmp    %dl,%cl
 10b:	75 f3                	jne    100 <strchr+0x20>
      return (char*)s;
  return 0;
}
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    
 10f:	90                   	nop
 110:	5d                   	pop    %ebp
  return 0;
 111:	31 c0                	xor    %eax,%eax
}
 113:	c3                   	ret    
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
 125:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 126:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 128:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 12b:	83 ec 3c             	sub    $0x3c,%esp
 12e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 131:	eb 3a                	jmp    16d <gets+0x4d>
 133:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 140:	89 7c 24 04          	mov    %edi,0x4(%esp)
 144:	ba 01 00 00 00       	mov    $0x1,%edx
 149:	89 54 24 08          	mov    %edx,0x8(%esp)
 14d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 154:	e8 32 01 00 00       	call   28b <read>
    if(cc < 1)
 159:	85 c0                	test   %eax,%eax
 15b:	7e 19                	jle    176 <gets+0x56>
      break;
    buf[i++] = c;
 15d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 161:	46                   	inc    %esi
 162:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 165:	3c 0a                	cmp    $0xa,%al
 167:	74 27                	je     190 <gets+0x70>
 169:	3c 0d                	cmp    $0xd,%al
 16b:	74 23                	je     190 <gets+0x70>
  for(i=0; i+1 < max; ){
 16d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 170:	43                   	inc    %ebx
 171:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 174:	7c ca                	jl     140 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 176:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 179:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	83 c4 3c             	add    $0x3c,%esp
 182:	5b                   	pop    %ebx
 183:	5e                   	pop    %esi
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18e:	66 90                	xchg   %ax,%ax
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	01 c3                	add    %eax,%ebx
 195:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 198:	eb dc                	jmp    176 <gets+0x56>
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a1:	31 c0                	xor    %eax,%eax
{
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 1a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
{
 1af:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1b2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 1b5:	89 04 24             	mov    %eax,(%esp)
 1b8:	e8 f6 00 00 00       	call   2b3 <open>
  if(fd < 0)
 1bd:	85 c0                	test   %eax,%eax
 1bf:	78 2f                	js     1f0 <stat+0x50>
 1c1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 1c 24             	mov    %ebx,(%esp)
 1c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cd:	e8 f9 00 00 00       	call   2cb <fstat>
  close(fd);
 1d2:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1d5:	89 c6                	mov    %eax,%esi
  close(fd);
 1d7:	e8 bf 00 00 00       	call   29b <close>
  return r;
}
 1dc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 1df:	89 f0                	mov    %esi,%eax
 1e1:	8b 75 fc             	mov    -0x4(%ebp),%esi
 1e4:	89 ec                	mov    %ebp,%esp
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    
 1e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop
    return -1;
 1f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f5:	eb e5                	jmp    1dc <stat+0x3c>
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax

00000200 <atoi>:

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	0f be 02             	movsbl (%edx),%eax
 20a:	88 c1                	mov    %al,%cl
 20c:	80 e9 30             	sub    $0x30,%cl
 20f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 212:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 217:	77 1c                	ja     235 <atoi+0x35>
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 220:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 223:	42                   	inc    %edx
 224:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 228:	0f be 02             	movsbl (%edx),%eax
 22b:	88 c3                	mov    %al,%bl
 22d:	80 eb 30             	sub    $0x30,%bl
 230:	80 fb 09             	cmp    $0x9,%bl
 233:	76 eb                	jbe    220 <atoi+0x20>
  return n;
}
 235:	5b                   	pop    %ebx
 236:	89 c8                	mov    %ecx,%eax
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 45 10             	mov    0x10(%ebp),%eax
 247:	56                   	push   %esi
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 c0                	test   %eax,%eax
 250:	7e 13                	jle    265 <memmove+0x25>
 252:	01 d0                	add    %edx,%eax
  dst = vdst;
 254:	89 d7                	mov    %edx,%edi
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 260:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 261:	39 f8                	cmp    %edi,%eax
 263:	75 fb                	jne    260 <memmove+0x20>
  return vdst;
}
 265:	5e                   	pop    %esi
 266:	89 d0                	mov    %edx,%eax
 268:	5f                   	pop    %edi
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    

0000026b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <exit>:
SYSCALL(exit)
 273:	b8 02 00 00 00       	mov    $0x2,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <wait>:
SYSCALL(wait)
 27b:	b8 03 00 00 00       	mov    $0x3,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <pipe>:
SYSCALL(pipe)
 283:	b8 04 00 00 00       	mov    $0x4,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <read>:
SYSCALL(read)
 28b:	b8 05 00 00 00       	mov    $0x5,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <write>:
SYSCALL(write)
 293:	b8 10 00 00 00       	mov    $0x10,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <close>:
SYSCALL(close)
 29b:	b8 15 00 00 00       	mov    $0x15,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <kill>:
SYSCALL(kill)
 2a3:	b8 06 00 00 00       	mov    $0x6,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <exec>:
SYSCALL(exec)
 2ab:	b8 07 00 00 00       	mov    $0x7,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <open>:
SYSCALL(open)
 2b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <mknod>:
SYSCALL(mknod)
 2bb:	b8 11 00 00 00       	mov    $0x11,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <unlink>:
SYSCALL(unlink)
 2c3:	b8 12 00 00 00       	mov    $0x12,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <fstat>:
SYSCALL(fstat)
 2cb:	b8 08 00 00 00       	mov    $0x8,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <link>:
SYSCALL(link)
 2d3:	b8 13 00 00 00       	mov    $0x13,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <mkdir>:
SYSCALL(mkdir)
 2db:	b8 14 00 00 00       	mov    $0x14,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <chdir>:
SYSCALL(chdir)
 2e3:	b8 09 00 00 00       	mov    $0x9,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <dup>:
SYSCALL(dup)
 2eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <getpid>:
SYSCALL(getpid)
 2f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <sbrk>:
SYSCALL(sbrk)
 2fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <sleep>:
SYSCALL(sleep)
 303:	b8 0d 00 00 00       	mov    $0xd,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <uptime>:
SYSCALL(uptime)
 30b:	b8 0e 00 00 00       	mov    $0xe,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <ps>:
SYSCALL(ps)
 313:	b8 16 00 00 00       	mov    $0x16,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	89 cf                	mov    %ecx,%edi
 326:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 327:	89 d1                	mov    %edx,%ecx
{
 329:	53                   	push   %ebx
 32a:	83 ec 4c             	sub    $0x4c,%esp
 32d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 330:	89 d0                	mov    %edx,%eax
 332:	c1 e8 1f             	shr    $0x1f,%eax
 335:	84 c0                	test   %al,%al
 337:	0f 84 a3 00 00 00    	je     3e0 <printint+0xc0>
 33d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 341:	0f 84 99 00 00 00    	je     3e0 <printint+0xc0>
    neg = 1;
 347:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 34e:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 350:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 357:	8d 75 d7             	lea    -0x29(%ebp),%esi
 35a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 360:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 363:	31 d2                	xor    %edx,%edx
 365:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 368:	f7 f7                	div    %edi
 36a:	8d 4b 01             	lea    0x1(%ebx),%ecx
 36d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 370:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 373:	39 cf                	cmp    %ecx,%edi
 375:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 378:	0f b6 92 60 07 00 00 	movzbl 0x760(%edx),%edx
 37f:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 383:	76 db                	jbe    360 <printint+0x40>
  if(neg)
 385:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 388:	85 c9                	test   %ecx,%ecx
 38a:	74 0c                	je     398 <printint+0x78>
    buf[i++] = '-';
 38c:	8b 45 c0             	mov    -0x40(%ebp),%eax
 38f:	b2 2d                	mov    $0x2d,%dl
 391:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 396:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 398:	8b 7d b8             	mov    -0x48(%ebp),%edi
 39b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 39f:	eb 13                	jmp    3b4 <printint+0x94>
 3a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop
 3b0:	0f b6 13             	movzbl (%ebx),%edx
 3b3:	4b                   	dec    %ebx
  write(fd, &c, 1);
 3b4:	89 74 24 04          	mov    %esi,0x4(%esp)
 3b8:	b8 01 00 00 00       	mov    $0x1,%eax
 3bd:	89 44 24 08          	mov    %eax,0x8(%esp)
 3c1:	89 3c 24             	mov    %edi,(%esp)
 3c4:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3c7:	e8 c7 fe ff ff       	call   293 <write>
  while(--i >= 0)
 3cc:	39 de                	cmp    %ebx,%esi
 3ce:	75 e0                	jne    3b0 <printint+0x90>
    putc(fd, buf[i]);
}
 3d0:	83 c4 4c             	add    $0x4c,%esp
 3d3:	5b                   	pop    %ebx
 3d4:	5e                   	pop    %esi
 3d5:	5f                   	pop    %edi
 3d6:	5d                   	pop    %ebp
 3d7:	c3                   	ret    
 3d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop
  neg = 0;
 3e0:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 3e7:	e9 64 ff ff ff       	jmp    350 <printint+0x30>
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3fc:	0f b6 1e             	movzbl (%esi),%ebx
 3ff:	84 db                	test   %bl,%bl
 401:	0f 84 c8 00 00 00    	je     4cf <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 407:	8d 45 10             	lea    0x10(%ebp),%eax
 40a:	46                   	inc    %esi
 40b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 40e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 411:	31 d2                	xor    %edx,%edx
 413:	eb 3e                	jmp    453 <printf+0x63>
 415:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 420:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 423:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 426:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 42b:	74 1e                	je     44b <printf+0x5b>
  write(fd, &c, 1);
 42d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 431:	b8 01 00 00 00       	mov    $0x1,%eax
 436:	89 44 24 08          	mov    %eax,0x8(%esp)
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 440:	89 04 24             	mov    %eax,(%esp)
 443:	e8 4b fe ff ff       	call   293 <write>
 448:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 44b:	0f b6 1e             	movzbl (%esi),%ebx
 44e:	46                   	inc    %esi
 44f:	84 db                	test   %bl,%bl
 451:	74 7c                	je     4cf <printf+0xdf>
    if(state == 0){
 453:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 455:	0f be cb             	movsbl %bl,%ecx
 458:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 45b:	74 c3                	je     420 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45d:	83 fa 25             	cmp    $0x25,%edx
 460:	75 e9                	jne    44b <printf+0x5b>
      if(c == 'd'){
 462:	83 f8 64             	cmp    $0x64,%eax
 465:	0f 84 a5 00 00 00    	je     510 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 46b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 471:	83 f9 70             	cmp    $0x70,%ecx
 474:	74 6a                	je     4e0 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 476:	83 f8 73             	cmp    $0x73,%eax
 479:	0f 84 e1 00 00 00    	je     560 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 47f:	83 f8 63             	cmp    $0x63,%eax
 482:	0f 84 98 00 00 00    	je     520 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 488:	83 f8 25             	cmp    $0x25,%eax
 48b:	74 1c                	je     4a9 <printf+0xb9>
  write(fd, &c, 1);
 48d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	ba 01 00 00 00       	mov    $0x1,%edx
 499:	89 54 24 08          	mov    %edx,0x8(%esp)
 49d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4a1:	89 04 24             	mov    %eax,(%esp)
 4a4:	e8 ea fd ff ff       	call   293 <write>
 4a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4ad:	b8 01 00 00 00       	mov    $0x1,%eax
 4b2:	46                   	inc    %esi
 4b3:	89 44 24 08          	mov    %eax,0x8(%esp)
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4bd:	89 04 24             	mov    %eax,(%esp)
 4c0:	e8 ce fd ff ff       	call   293 <write>
  for(i = 0; fmt[i]; i++){
 4c5:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4cb:	84 db                	test   %bl,%bl
 4cd:	75 84                	jne    453 <printf+0x63>
    }
  }
}
 4cf:	83 c4 3c             	add    $0x3c,%esp
 4d2:	5b                   	pop    %ebx
 4d3:	5e                   	pop    %esi
 4d4:	5f                   	pop    %edi
 4d5:	5d                   	pop    %ebp
 4d6:	c3                   	ret    
 4d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4e7:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ec:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	8b 13                	mov    (%ebx),%edx
 4f4:	e8 27 fe ff ff       	call   320 <printint>
        ap++;
 4f9:	89 d8                	mov    %ebx,%eax
      state = 0;
 4fb:	31 d2                	xor    %edx,%edx
        ap++;
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 d0             	mov    %eax,-0x30(%ebp)
 503:	e9 43 ff ff ff       	jmp    44b <printf+0x5b>
 508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop
        printint(fd, *ap, 10, 1);
 510:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 517:	b9 0a 00 00 00       	mov    $0xa,%ecx
 51c:	eb ce                	jmp    4ec <printf+0xfc>
 51e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 520:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 523:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 528:	8b 03                	mov    (%ebx),%eax
        ap++;
 52a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 52d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 531:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 535:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 538:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 53c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	89 04 24             	mov    %eax,(%esp)
 545:	e8 49 fd ff ff       	call   293 <write>
      state = 0;
 54a:	31 d2                	xor    %edx,%edx
        ap++;
 54c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 54f:	e9 f7 fe ff ff       	jmp    44b <printf+0x5b>
 554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
        s = (char*)*ap;
 560:	8b 45 d0             	mov    -0x30(%ebp),%eax
 563:	8b 18                	mov    (%eax),%ebx
        ap++;
 565:	83 c0 04             	add    $0x4,%eax
 568:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 56b:	85 db                	test   %ebx,%ebx
 56d:	74 11                	je     580 <printf+0x190>
        while(*s != 0){
 56f:	0f b6 03             	movzbl (%ebx),%eax
 572:	84 c0                	test   %al,%al
 574:	74 44                	je     5ba <printf+0x1ca>
 576:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 579:	89 de                	mov    %ebx,%esi
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 57e:	eb 10                	jmp    590 <printf+0x1a0>
 580:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 583:	bb 58 07 00 00       	mov    $0x758,%ebx
        while(*s != 0){
 588:	b0 28                	mov    $0x28,%al
 58a:	89 de                	mov    %ebx,%esi
 58c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 58f:	90                   	nop
          putc(fd, *s);
 590:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 593:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 598:	46                   	inc    %esi
  write(fd, &c, 1);
 599:	89 44 24 08          	mov    %eax,0x8(%esp)
 59d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5a1:	89 1c 24             	mov    %ebx,(%esp)
 5a4:	e8 ea fc ff ff       	call   293 <write>
        while(*s != 0){
 5a9:	0f b6 06             	movzbl (%esi),%eax
 5ac:	84 c0                	test   %al,%al
 5ae:	75 e0                	jne    590 <printf+0x1a0>
 5b0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5b3:	31 d2                	xor    %edx,%edx
 5b5:	e9 91 fe ff ff       	jmp    44b <printf+0x5b>
 5ba:	31 d2                	xor    %edx,%edx
 5bc:	e9 8a fe ff ff       	jmp    44b <printf+0x5b>
 5c1:	66 90                	xchg   %ax,%ax
 5c3:	66 90                	xchg   %ax,%ax
 5c5:	66 90                	xchg   %ax,%ax
 5c7:	66 90                	xchg   %ax,%ax
 5c9:	66 90                	xchg   %ax,%ax
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 f4 09 00 00       	mov    0x9f4,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5de:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5e0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e3:	39 c8                	cmp    %ecx,%eax
 5e5:	73 19                	jae    600 <free+0x30>
 5e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ee:	66 90                	xchg   %ax,%ax
 5f0:	39 d1                	cmp    %edx,%ecx
 5f2:	72 14                	jb     608 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f4:	39 d0                	cmp    %edx,%eax
 5f6:	73 10                	jae    608 <free+0x38>
{
 5f8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fa:	39 c8                	cmp    %ecx,%eax
 5fc:	8b 10                	mov    (%eax),%edx
 5fe:	72 f0                	jb     5f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	39 d0                	cmp    %edx,%eax
 602:	72 f4                	jb     5f8 <free+0x28>
 604:	39 d1                	cmp    %edx,%ecx
 606:	73 f0                	jae    5f8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 fa                	cmp    %edi,%edx
 610:	74 1e                	je     630 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 612:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 615:	8b 50 04             	mov    0x4(%eax),%edx
 618:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61b:	39 f1                	cmp    %esi,%ecx
 61d:	74 2a                	je     649 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 61f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 621:	5b                   	pop    %ebx
  freep = p;
 622:	a3 f4 09 00 00       	mov    %eax,0x9f4
}
 627:	5e                   	pop    %esi
 628:	5f                   	pop    %edi
 629:	5d                   	pop    %ebp
 62a:	c3                   	ret    
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 630:	8b 7a 04             	mov    0x4(%edx),%edi
 633:	01 fe                	add    %edi,%esi
 635:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 638:	8b 10                	mov    (%eax),%edx
 63a:	8b 12                	mov    (%edx),%edx
 63c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63f:	8b 50 04             	mov    0x4(%eax),%edx
 642:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 645:	39 f1                	cmp    %esi,%ecx
 647:	75 d6                	jne    61f <free+0x4f>
  freep = p;
 649:	a3 f4 09 00 00       	mov    %eax,0x9f4
    p->s.size += bp->s.size;
 64e:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 651:	01 ca                	add    %ecx,%edx
 653:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 656:	8b 53 f8             	mov    -0x8(%ebx),%edx
 659:	89 10                	mov    %edx,(%eax)
}
 65b:	5b                   	pop    %ebx
 65c:	5e                   	pop    %esi
 65d:	5f                   	pop    %edi
 65e:	5d                   	pop    %ebp
 65f:	c3                   	ret    

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 3d f4 09 00 00    	mov    0x9f4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 70 07             	lea    0x7(%eax),%esi
 675:	c1 ee 03             	shr    $0x3,%esi
 678:	46                   	inc    %esi
  if((prevp = freep) == 0){
 679:	85 ff                	test   %edi,%edi
 67b:	0f 84 9f 00 00 00    	je     720 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 681:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 683:	8b 48 04             	mov    0x4(%eax),%ecx
 686:	39 f1                	cmp    %esi,%ecx
 688:	73 6c                	jae    6f6 <malloc+0x96>
 68a:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 690:	bb 00 10 00 00       	mov    $0x1000,%ebx
 695:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 698:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 69f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6a2:	eb 1d                	jmp    6c1 <malloc+0x61>
 6a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6b2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6b5:	39 f1                	cmp    %esi,%ecx
 6b7:	73 47                	jae    700 <malloc+0xa0>
 6b9:	8b 3d f4 09 00 00    	mov    0x9f4,%edi
 6bf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c1:	39 c7                	cmp    %eax,%edi
 6c3:	75 eb                	jne    6b0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c8:	89 04 24             	mov    %eax,(%esp)
 6cb:	e8 2b fc ff ff       	call   2fb <sbrk>
  if(p == (char*)-1)
 6d0:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d3:	74 17                	je     6ec <malloc+0x8c>
  hp->s.size = nu;
 6d5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6d8:	83 c0 08             	add    $0x8,%eax
 6db:	89 04 24             	mov    %eax,(%esp)
 6de:	e8 ed fe ff ff       	call   5d0 <free>
  return freep;
 6e3:	a1 f4 09 00 00       	mov    0x9f4,%eax
      if((p = morecore(nunits)) == 0)
 6e8:	85 c0                	test   %eax,%eax
 6ea:	75 c4                	jne    6b0 <malloc+0x50>
        return 0;
  }
}
 6ec:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 6ef:	31 c0                	xor    %eax,%eax
}
 6f1:	5b                   	pop    %ebx
 6f2:	5e                   	pop    %esi
 6f3:	5f                   	pop    %edi
 6f4:	5d                   	pop    %ebp
 6f5:	c3                   	ret    
    if(p->s.size >= nunits){
 6f6:	89 c2                	mov    %eax,%edx
 6f8:	89 f8                	mov    %edi,%eax
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 700:	39 ce                	cmp    %ecx,%esi
 702:	74 4c                	je     750 <malloc+0xf0>
        p->s.size -= nunits;
 704:	29 f1                	sub    %esi,%ecx
 706:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 709:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 70c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 70f:	a3 f4 09 00 00       	mov    %eax,0x9f4
      return (void*)(p + 1);
 714:	8d 42 08             	lea    0x8(%edx),%eax
}
 717:	83 c4 2c             	add    $0x2c,%esp
 71a:	5b                   	pop    %ebx
 71b:	5e                   	pop    %esi
 71c:	5f                   	pop    %edi
 71d:	5d                   	pop    %ebp
 71e:	c3                   	ret    
 71f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 720:	b8 f8 09 00 00       	mov    $0x9f8,%eax
 725:	ba f8 09 00 00       	mov    $0x9f8,%edx
 72a:	a3 f4 09 00 00       	mov    %eax,0x9f4
    base.s.size = 0;
 72f:	31 c9                	xor    %ecx,%ecx
 731:	bf f8 09 00 00       	mov    $0x9f8,%edi
    base.s.ptr = freep = prevp = &base;
 736:	89 15 f8 09 00 00    	mov    %edx,0x9f8
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 73e:	89 0d fc 09 00 00    	mov    %ecx,0x9fc
    if(p->s.size >= nunits){
 744:	e9 41 ff ff ff       	jmp    68a <malloc+0x2a>
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 750:	8b 0a                	mov    (%edx),%ecx
 752:	89 08                	mov    %ecx,(%eax)
 754:	eb b9                	jmp    70f <malloc+0xaf>


kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 30 10 80       	mov    $0x801030e0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100041:	ba 20 72 10 80       	mov    $0x80107220,%edx
{
80100046:	89 e5                	mov    %esp,%ebp
80100048:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100049:	bb bc fc 10 80       	mov    $0x8010fcbc,%ebx
{
8010004e:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
80100051:	89 54 24 04          	mov    %edx,0x4(%esp)
80100055:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005c:	e8 cf 44 00 00       	call   80104530 <initlock>
  bcache.head.prev = &bcache.head;
80100061:	b9 bc fc 10 80       	mov    $0x8010fcbc,%ecx
  bcache.head.next = &bcache.head;
80100066:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
8010006b:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  bcache.head.prev = &bcache.head;
80100076:	89 0d 0c fd 10 80    	mov    %ecx,0x8010fd0c
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007c:	eb 04                	jmp    80100082 <binit+0x42>
8010007e:	66 90                	xchg   %ax,%ax
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	b8 27 72 10 80       	mov    $0x80107227,%eax
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 44 24 04          	mov    %eax,0x4(%esp)
80100095:	8d 43 0c             	lea    0xc(%ebx),%eax
80100098:	89 04 24             	mov    %eax,(%esp)
8010009b:	e8 50 43 00 00       	call   801043f0 <initsleeplock>
    bcache.head.next->prev = b;
801000a0:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a5:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000ab:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
    bcache.head.next->prev = b;
801000b1:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000b4:	89 d8                	mov    %ebx,%eax
801000b6:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	83 c4 14             	add    $0x14,%esp
801000c1:	5b                   	pop    %ebx
801000c2:	5d                   	pop    %ebp
801000c3:	c3                   	ret    
801000c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000cf:	90                   	nop

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&bcache.lock);
801000d9:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e0:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e6:	e8 b5 45 00 00       	call   801046a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000ff:	90                   	nop
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	ff 43 4c             	incl   0x4c(%ebx)
      release(&bcache.lock);
80100118:	eb 40                	jmp    8010015a <bread+0x8a>
8010011a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ea 45 00 00       	call   80104750 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 bf 42 00 00       	call   80104430 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	74 0a                	je     80100180 <bread+0xb0>
    iderw(b);
  }
  return b;
}
80100176:	83 c4 1c             	add    $0x1c,%esp
80100179:	89 d8                	mov    %ebx,%eax
8010017b:	5b                   	pop    %ebx
8010017c:	5e                   	pop    %esi
8010017d:	5f                   	pop    %edi
8010017e:	5d                   	pop    %ebp
8010017f:	c3                   	ret    
    iderw(b);
80100180:	89 1c 24             	mov    %ebx,(%esp)
80100183:	e8 18 22 00 00       	call   801023a0 <iderw>
}
80100188:	83 c4 1c             	add    $0x1c,%esp
8010018b:	89 d8                	mov    %ebx,%eax
8010018d:	5b                   	pop    %ebx
8010018e:	5e                   	pop    %esi
8010018f:	5f                   	pop    %edi
80100190:	5d                   	pop    %ebp
80100191:	c3                   	ret    
80100192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  panic("bget: no buffers");
801001a0:	c7 04 24 2e 72 10 80 	movl   $0x8010722e,(%esp)
801001a7:	e8 b4 01 00 00       	call   80100360 <panic>
801001ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 14             	sub    $0x14,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	89 04 24             	mov    %eax,(%esp)
801001c0:	e8 0b 43 00 00       	call   801044d0 <holdingsleep>
801001c5:	85 c0                	test   %eax,%eax
801001c7:	74 10                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001cf:	83 c4 14             	add    $0x14,%esp
801001d2:	5b                   	pop    %ebx
801001d3:	5d                   	pop    %ebp
  iderw(b);
801001d4:	e9 c7 21 00 00       	jmp    801023a0 <iderw>
    panic("bwrite");
801001d9:	c7 04 24 3f 72 10 80 	movl   $0x8010723f,(%esp)
801001e0:	e8 7b 01 00 00       	call   80100360 <panic>
801001e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	83 ec 10             	sub    $0x10,%esp
801001f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fe:	89 34 24             	mov    %esi,(%esp)
80100201:	e8 ca 42 00 00       	call   801044d0 <holdingsleep>
80100206:	85 c0                	test   %eax,%eax
80100208:	74 5a                	je     80100264 <brelse+0x74>
    panic("brelse");

  releasesleep(&b->lock);
8010020a:	89 34 24             	mov    %esi,(%esp)
8010020d:	e8 7e 42 00 00       	call   80104490 <releasesleep>

  acquire(&bcache.lock);
80100212:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100219:	e8 82 44 00 00       	call   801046a0 <acquire>
  b->refcnt--;
8010021e:	ff 4b 4c             	decl   0x4c(%ebx)
  if (b->refcnt == 0) {
80100221:	75 2f                	jne    80100252 <brelse+0x62>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100223:	8b 43 54             	mov    0x54(%ebx),%eax
80100226:	8b 53 50             	mov    0x50(%ebx),%edx
80100229:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022c:	8b 43 50             	mov    0x50(%ebx),%eax
8010022f:	8b 53 54             	mov    0x54(%ebx),%edx
80100232:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010023a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100241:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100244:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100249:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024c:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100252:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100259:	83 c4 10             	add    $0x10,%esp
8010025c:	5b                   	pop    %ebx
8010025d:	5e                   	pop    %esi
8010025e:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025f:	e9 ec 44 00 00       	jmp    80104750 <release>
    panic("brelse");
80100264:	c7 04 24 46 72 10 80 	movl   $0x80107246,(%esp)
8010026b:	e8 f0 00 00 00       	call   80100360 <panic>

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 2c             	sub    $0x2c,%esp
80100279:	8b 75 08             	mov    0x8(%ebp),%esi
8010027c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 34 24             	mov    %esi,(%esp)
80100282:	e8 59 16 00 00       	call   801018e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
  target = n;
8010028e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100291:	e8 0a 44 00 00       	call   801046a0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100296:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100299:	01 df                	add    %ebx,%edi
  while(n > 0){
8010029b:	85 db                	test   %ebx,%ebx
8010029d:	7f 32                	jg     801002d1 <consoleread+0x61>
8010029f:	eb 64                	jmp    80100305 <consoleread+0x95>
801002a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002af:	90                   	nop
      if(myproc()->killed){
801002b0:	e8 4b 37 00 00       	call   80103a00 <myproc>
801002b5:	8b 50 24             	mov    0x24(%eax),%edx
801002b8:	85 d2                	test   %edx,%edx
801002ba:	75 74                	jne    80100330 <consoleread+0xc0>
      sleep(&input.r, &cons.lock);
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	b8 20 a5 10 80       	mov    $0x8010a520,%eax
801002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801002cc:	e8 bf 3c 00 00       	call   80103f90 <sleep>
    while(input.r == input.w){
801002d1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002d6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
    c = input.buf[input.r++ % INPUT_BUF];
801002de:	8d 50 01             	lea    0x1(%eax),%edx
801002e1:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002e7:	89 c2                	mov    %eax,%edx
801002e9:	83 e2 7f             	and    $0x7f,%edx
801002ec:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
801002f3:	80 f9 04             	cmp    $0x4,%cl
801002f6:	74 59                	je     80100351 <consoleread+0xe1>
    *dst++ = c;
801002f8:	89 d8                	mov    %ebx,%eax
    --n;
801002fa:	4b                   	dec    %ebx
    *dst++ = c;
801002fb:	f7 d8                	neg    %eax
    if(c == '\n')
801002fd:	83 f9 0a             	cmp    $0xa,%ecx
    *dst++ = c;
80100300:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100303:	75 96                	jne    8010029b <consoleread+0x2b>
      break;
  }
  release(&cons.lock);
80100305:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030c:	e8 3f 44 00 00       	call   80104750 <release>
  ilock(ip);
80100311:	89 34 24             	mov    %esi,(%esp)
80100314:	e8 e7 14 00 00       	call   80101800 <ilock>

  return target - n;
80100319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010031c:	83 c4 2c             	add    $0x2c,%esp
  return target - n;
8010031f:	29 d8                	sub    %ebx,%eax
}
80100321:	5b                   	pop    %ebx
80100322:	5e                   	pop    %esi
80100323:	5f                   	pop    %edi
80100324:	5d                   	pop    %ebp
80100325:	c3                   	ret    
80100326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010032d:	8d 76 00             	lea    0x0(%esi),%esi
        release(&cons.lock);
80100330:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100337:	e8 14 44 00 00       	call   80104750 <release>
        ilock(ip);
8010033c:	89 34 24             	mov    %esi,(%esp)
8010033f:	e8 bc 14 00 00       	call   80101800 <ilock>
}
80100344:	83 c4 2c             	add    $0x2c,%esp
        return -1;
80100347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010034c:	5b                   	pop    %ebx
8010034d:	5e                   	pop    %esi
8010034e:	5f                   	pop    %edi
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    
      if(n < target){
80100351:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100354:	73 af                	jae    80100305 <consoleread+0x95>
        input.r--;
80100356:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010035b:	eb a8                	jmp    80100305 <consoleread+0x95>
8010035d:	8d 76 00             	lea    0x0(%esi),%esi

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  getcallerpcs(&s, pcs);
80100369:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cons.locking = 0;
8010036c:	31 d2                	xor    %edx,%edx
8010036e:	89 15 54 a5 10 80    	mov    %edx,0x8010a554
  cprintf("lapicid %d: panic: ", lapicid());
80100374:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100377:	e8 44 26 00 00       	call   801029c0 <lapicid>
8010037c:	c7 04 24 4d 72 10 80 	movl   $0x8010724d,(%esp)
80100383:	89 44 24 04          	mov    %eax,0x4(%esp)
80100387:	e8 f4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
8010038c:	8b 45 08             	mov    0x8(%ebp),%eax
8010038f:	89 04 24             	mov    %eax,(%esp)
80100392:	e8 e9 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
80100397:	c7 04 24 2b 78 10 80 	movl   $0x8010782b,(%esp)
8010039e:	e8 dd 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003aa:	89 04 24             	mov    %eax,(%esp)
801003ad:	e8 9e 41 00 00       	call   80104550 <getcallerpcs>
    cprintf(" %p", pcs[i]);
801003b2:	8b 03                	mov    (%ebx),%eax
801003b4:	83 c3 04             	add    $0x4,%ebx
801003b7:	c7 04 24 61 72 10 80 	movl   $0x80107261,(%esp)
801003be:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c2:	e8 b9 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003c7:	39 f3                	cmp    %esi,%ebx
801003c9:	75 e7                	jne    801003b2 <panic+0x52>
  panicked = 1; // freeze other CPU
801003cb:	b8 01 00 00 00       	mov    $0x1,%eax
801003d0:	a3 58 a5 10 80       	mov    %eax,0x8010a558
  for(;;)
801003d5:	eb fe                	jmp    801003d5 <panic+0x75>
801003d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003de:	66 90                	xchg   %ax,%ax

801003e0 <consputc.part.0>:
consputc(int c)
801003e0:	55                   	push   %ebp
801003e1:	89 e5                	mov    %esp,%ebp
801003e3:	57                   	push   %edi
801003e4:	56                   	push   %esi
801003e5:	53                   	push   %ebx
801003e6:	89 c3                	mov    %eax,%ebx
801003e8:	83 ec 2c             	sub    $0x2c,%esp
  if(c == BACKSPACE){
801003eb:	3d 00 01 00 00       	cmp    $0x100,%eax
801003f0:	0f 84 ea 00 00 00    	je     801004e0 <consputc.part.0+0x100>
    uartputc(c);
801003f6:	89 04 24             	mov    %eax,(%esp)
801003f9:	e8 d2 59 00 00       	call   80105dd0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003fe:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100403:	b0 0e                	mov    $0xe,%al
80100405:	89 fa                	mov    %edi,%edx
80100407:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100408:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010040d:	89 ca                	mov    %ecx,%edx
8010040f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100410:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100413:	89 fa                	mov    %edi,%edx
80100415:	c1 e6 08             	shl    $0x8,%esi
80100418:	b0 0f                	mov    $0xf,%al
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	89 ca                	mov    %ecx,%edx
8010041d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010041e:	0f b6 c8             	movzbl %al,%ecx
80100421:	09 f1                	or     %esi,%ecx
  if(c == '\n')
80100423:	83 fb 0a             	cmp    $0xa,%ebx
80100426:	0f 84 94 00 00 00    	je     801004c0 <consputc.part.0+0xe0>
  else if(c == BACKSPACE){
8010042c:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100432:	74 6c                	je     801004a0 <consputc.part.0+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100434:	8d 51 01             	lea    0x1(%ecx),%edx
80100437:	0f b6 db             	movzbl %bl,%ebx
8010043a:	81 cb 00 07 00 00    	or     $0x700,%ebx
80100440:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
80100447:	80 
  if(pos < 0 || pos > 25*80)
80100448:	81 fa d0 07 00 00    	cmp    $0x7d0,%edx
8010044e:	0f 8f 0f 01 00 00    	jg     80100563 <consputc.part.0+0x183>
  if((pos/80) >= 24){  // Scroll up.
80100454:	81 fa 7f 07 00 00    	cmp    $0x77f,%edx
8010045a:	0f 8f b0 00 00 00    	jg     80100510 <consputc.part.0+0x130>
80100460:	88 55 e4             	mov    %dl,-0x1c(%ebp)
80100463:	8d bc 12 00 80 0b 80 	lea    -0x7ff48000(%edx,%edx,1),%edi
8010046a:	0f b6 ce             	movzbl %dh,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010046d:	be d4 03 00 00       	mov    $0x3d4,%esi
80100472:	b0 0e                	mov    $0xe,%al
80100474:	89 f2                	mov    %esi,%edx
80100476:	ee                   	out    %al,(%dx)
80100477:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010047c:	88 c8                	mov    %cl,%al
8010047e:	89 da                	mov    %ebx,%edx
80100480:	ee                   	out    %al,(%dx)
80100481:	b0 0f                	mov    $0xf,%al
80100483:	89 f2                	mov    %esi,%edx
80100485:	ee                   	out    %al,(%dx)
80100486:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
8010048a:	89 da                	mov    %ebx,%edx
8010048c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010048d:	66 c7 07 20 07       	movw   $0x720,(%edi)
}
80100492:	83 c4 2c             	add    $0x2c,%esp
80100495:	5b                   	pop    %ebx
80100496:	5e                   	pop    %esi
80100497:	5f                   	pop    %edi
80100498:	5d                   	pop    %ebp
80100499:	c3                   	ret    
8010049a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pos > 0) --pos;
801004a0:	8d 51 ff             	lea    -0x1(%ecx),%edx
801004a3:	85 c9                	test   %ecx,%ecx
801004a5:	75 a1                	jne    80100448 <consputc.part.0+0x68>
801004a7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004ab:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
801004b0:	31 c9                	xor    %ecx,%ecx
801004b2:	eb b9                	jmp    8010046d <consputc.part.0+0x8d>
801004b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004bf:	90                   	nop
    pos += 80 - pos%80;
801004c0:	89 c8                	mov    %ecx,%eax
801004c2:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004c7:	f7 e2                	mul    %edx
801004c9:	c1 ea 06             	shr    $0x6,%edx
801004cc:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004cf:	c1 e0 04             	shl    $0x4,%eax
801004d2:	8d 50 50             	lea    0x50(%eax),%edx
801004d5:	e9 6e ff ff ff       	jmp    80100448 <consputc.part.0+0x68>
801004da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004e7:	e8 e4 58 00 00       	call   80105dd0 <uartputc>
801004ec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f3:	e8 d8 58 00 00       	call   80105dd0 <uartputc>
801004f8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004ff:	e8 cc 58 00 00       	call   80105dd0 <uartputc>
80100504:	e9 f5 fe ff ff       	jmp    801003fe <consputc.part.0+0x1e>
80100509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100510:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100513:	b8 60 0e 00 00       	mov    $0xe60,%eax
80100518:	ba a0 80 0b 80       	mov    $0x800b80a0,%edx
8010051d:	89 54 24 04          	mov    %edx,0x4(%esp)
80100521:	89 44 24 08          	mov    %eax,0x8(%esp)
80100525:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
8010052c:	e8 2f 43 00 00       	call   80104860 <memmove>
    pos -= 80;
80100531:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100534:	b8 80 07 00 00       	mov    $0x780,%eax
80100539:	31 c9                	xor    %ecx,%ecx
8010053b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    pos -= 80;
8010053f:	8d 5a b0             	lea    -0x50(%edx),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100542:	8d bc 12 60 7f 0b 80 	lea    -0x7ff480a0(%edx,%edx,1),%edi
80100549:	29 d8                	sub    %ebx,%eax
8010054b:	89 3c 24             	mov    %edi,(%esp)
8010054e:	01 c0                	add    %eax,%eax
80100550:	89 44 24 08          	mov    %eax,0x8(%esp)
80100554:	e8 47 42 00 00       	call   801047a0 <memset>
80100559:	b1 07                	mov    $0x7,%cl
8010055b:	88 5d e4             	mov    %bl,-0x1c(%ebp)
8010055e:	e9 0a ff ff ff       	jmp    8010046d <consputc.part.0+0x8d>
    panic("pos under/overflow");
80100563:	c7 04 24 65 72 10 80 	movl   $0x80107265,(%esp)
8010056a:	e8 f1 fd ff ff       	call   80100360 <panic>
8010056f:	90                   	nop

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	53                   	push   %ebx
80100576:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
80100579:	85 c9                	test   %ecx,%ecx
{
8010057b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010057e:	74 04                	je     80100584 <printint+0x14>
80100580:	85 c0                	test   %eax,%eax
80100582:	78 6e                	js     801005f2 <printint+0x82>
    x = xx;
80100584:	89 c1                	mov    %eax,%ecx
80100586:	31 ff                	xor    %edi,%edi
  i = 0;
80100588:	89 7d cc             	mov    %edi,-0x34(%ebp)
8010058b:	8d 75 d7             	lea    -0x29(%ebp),%esi
8010058e:	31 db                	xor    %ebx,%ebx
    buf[i++] = digits[x % base];
80100590:	89 c8                	mov    %ecx,%eax
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 75 d4             	divl   -0x2c(%ebp)
80100597:	89 cf                	mov    %ecx,%edi
80100599:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010059c:	0f b6 92 90 72 10 80 	movzbl -0x7fef8d70(%edx),%edx
801005a3:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);
801005a5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    buf[i++] = digits[x % base];
801005a8:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005ab:	89 7d d0             	mov    %edi,-0x30(%ebp)
801005ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
801005b1:	39 7d d0             	cmp    %edi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005b4:	88 54 06 01          	mov    %dl,0x1(%esi,%eax,1)
  }while((x /= base) != 0);
801005b8:	73 d6                	jae    80100590 <printint+0x20>
801005ba:	8b 7d cc             	mov    -0x34(%ebp),%edi
  if(sign)
801005bd:	85 ff                	test   %edi,%edi
801005bf:	74 09                	je     801005ca <printint+0x5a>
    buf[i++] = '-';
801005c1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005c6:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005c8:	b2 2d                	mov    $0x2d,%dl
  while(--i >= 0)
801005ca:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
  if(panicked){
801005ce:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801005d3:	85 c0                	test   %eax,%eax
801005d5:	74 09                	je     801005e0 <printint+0x70>
  asm volatile("cli");
801005d7:	fa                   	cli    
    for(;;)
801005d8:	eb fe                	jmp    801005d8 <printint+0x68>
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005e0:	0f be c2             	movsbl %dl,%eax
801005e3:	e8 f8 fd ff ff       	call   801003e0 <consputc.part.0>
  while(--i >= 0)
801005e8:	39 f3                	cmp    %esi,%ebx
801005ea:	74 0e                	je     801005fa <printint+0x8a>
801005ec:	0f b6 13             	movzbl (%ebx),%edx
801005ef:	4b                   	dec    %ebx
801005f0:	eb dc                	jmp    801005ce <printint+0x5e>
    x = -xx;
801005f2:	f7 d8                	neg    %eax
801005f4:	89 cf                	mov    %ecx,%edi
801005f6:	89 c1                	mov    %eax,%ecx
801005f8:	eb 8e                	jmp    80100588 <printint+0x18>
}
801005fa:	83 c4 2c             	add    $0x2c,%esp
801005fd:	5b                   	pop    %ebx
801005fe:	5e                   	pop    %esi
801005ff:	5f                   	pop    %edi
80100600:	5d                   	pop    %ebp
80100601:	c3                   	ret    
80100602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100610 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100610:	55                   	push   %ebp
80100611:	89 e5                	mov    %esp,%ebp
80100613:	57                   	push   %edi
80100614:	56                   	push   %esi
80100615:	53                   	push   %ebx
80100616:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
80100619:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010061c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
8010061f:	89 04 24             	mov    %eax,(%esp)
80100622:	e8 b9 12 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
80100627:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010062e:	e8 6d 40 00 00       	call   801046a0 <acquire>
  for(i = 0; i < n; i++)
80100633:	85 db                	test   %ebx,%ebx
80100635:	7e 26                	jle    8010065d <consolewrite+0x4d>
80100637:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010063a:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
8010063d:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100642:	85 c0                	test   %eax,%eax
80100644:	74 0a                	je     80100650 <consolewrite+0x40>
80100646:	fa                   	cli    
    for(;;)
80100647:	eb fe                	jmp    80100647 <consolewrite+0x37>
80100649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
80100650:	0f b6 07             	movzbl (%edi),%eax
80100653:	47                   	inc    %edi
80100654:	e8 87 fd ff ff       	call   801003e0 <consputc.part.0>
  for(i = 0; i < n; i++)
80100659:	39 fe                	cmp    %edi,%esi
8010065b:	75 e0                	jne    8010063d <consolewrite+0x2d>
  release(&cons.lock);
8010065d:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100664:	e8 e7 40 00 00       	call   80104750 <release>
  ilock(ip);
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	89 04 24             	mov    %eax,(%esp)
8010066f:	e8 8c 11 00 00       	call   80101800 <ilock>

  return n;
}
80100674:	83 c4 1c             	add    $0x1c,%esp
80100677:	89 d8                	mov    %ebx,%eax
80100679:	5b                   	pop    %ebx
8010067a:	5e                   	pop    %esi
8010067b:	5f                   	pop    %edi
8010067c:	5d                   	pop    %ebp
8010067d:	c3                   	ret    
8010067e:	66 90                	xchg   %ax,%ax

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 2c             	sub    $0x2c,%esp
  locking = cons.locking;
80100689:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010068e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 f4 00 00 00    	jne    8010078d <cprintf+0x10d>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 6d 01 00 00    	je     80100811 <cprintf+0x191>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
801006a7:	85 c0                	test   %eax,%eax
801006a9:	74 3d                	je     801006e8 <cprintf+0x68>
801006ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
801006b2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
    if(c != '%'){
801006b5:	83 f8 25             	cmp    $0x25,%eax
801006b8:	74 46                	je     80100700 <cprintf+0x80>
  if(panicked){
801006ba:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006c0:	85 c9                	test   %ecx,%ecx
801006c2:	74 11                	je     801006d5 <cprintf+0x55>
801006c4:	fa                   	cli    
    for(;;)
801006c5:	eb fe                	jmp    801006c5 <cprintf+0x45>
801006c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006ce:	66 90                	xchg   %ax,%ax
801006d0:	b8 25 00 00 00       	mov    $0x25,%eax
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	ff 45 e4             	incl   -0x1c(%ebp)
801006dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006e0:	0f b6 04 06          	movzbl (%esi,%eax,1),%eax
801006e4:	85 c0                	test   %eax,%eax
801006e6:	75 cd                	jne    801006b5 <cprintf+0x35>
  if(locking)
801006e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006eb:	85 c0                	test   %eax,%eax
801006ed:	0f 85 0d 01 00 00    	jne    80100800 <cprintf+0x180>
}
801006f3:	83 c4 2c             	add    $0x2c,%esp
801006f6:	5b                   	pop    %ebx
801006f7:	5e                   	pop    %esi
801006f8:	5f                   	pop    %edi
801006f9:	5d                   	pop    %ebp
801006fa:	c3                   	ret    
801006fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006ff:	90                   	nop
    c = fmt[++i] & 0xff;
80100700:	ff 45 e4             	incl   -0x1c(%ebp)
80100703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100706:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
    if(c == 0)
8010070a:	85 ff                	test   %edi,%edi
8010070c:	74 da                	je     801006e8 <cprintf+0x68>
    switch(c){
8010070e:	83 ff 70             	cmp    $0x70,%edi
80100711:	74 62                	je     80100775 <cprintf+0xf5>
80100713:	7f 2a                	jg     8010073f <cprintf+0xbf>
80100715:	83 ff 25             	cmp    $0x25,%edi
80100718:	0f 84 94 00 00 00    	je     801007b2 <cprintf+0x132>
8010071e:	83 ff 64             	cmp    $0x64,%edi
80100721:	0f 85 a9 00 00 00    	jne    801007d0 <cprintf+0x150>
      printint(*argp++, 10, 1);
80100727:	8b 03                	mov    (%ebx),%eax
80100729:	8d 7b 04             	lea    0x4(%ebx),%edi
8010072c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100731:	ba 0a 00 00 00       	mov    $0xa,%edx
80100736:	89 fb                	mov    %edi,%ebx
80100738:	e8 33 fe ff ff       	call   80100570 <printint>
      break;
8010073d:	eb 9b                	jmp    801006da <cprintf+0x5a>
    switch(c){
8010073f:	83 ff 73             	cmp    $0x73,%edi
80100742:	75 2c                	jne    80100770 <cprintf+0xf0>
      if((s = (char*)*argp++) == 0)
80100744:	8d 7b 04             	lea    0x4(%ebx),%edi
80100747:	8b 1b                	mov    (%ebx),%ebx
80100749:	85 db                	test   %ebx,%ebx
8010074b:	75 57                	jne    801007a4 <cprintf+0x124>
        s = "(null)";
8010074d:	bb 78 72 10 80       	mov    $0x80107278,%ebx
      for(; *s; s++)
80100752:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100757:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010075d:	85 d2                	test   %edx,%edx
8010075f:	74 3d                	je     8010079e <cprintf+0x11e>
80100761:	fa                   	cli    
    for(;;)
80100762:	eb fe                	jmp    80100762 <cprintf+0xe2>
80100764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010076b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010076f:	90                   	nop
    switch(c){
80100770:	83 ff 78             	cmp    $0x78,%edi
80100773:	75 5b                	jne    801007d0 <cprintf+0x150>
      printint(*argp++, 16, 0);
80100775:	8b 03                	mov    (%ebx),%eax
80100777:	8d 7b 04             	lea    0x4(%ebx),%edi
8010077a:	31 c9                	xor    %ecx,%ecx
8010077c:	ba 10 00 00 00       	mov    $0x10,%edx
80100781:	89 fb                	mov    %edi,%ebx
80100783:	e8 e8 fd ff ff       	call   80100570 <printint>
      break;
80100788:	e9 4d ff ff ff       	jmp    801006da <cprintf+0x5a>
    acquire(&cons.lock);
8010078d:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100794:	e8 07 3f 00 00       	call   801046a0 <acquire>
80100799:	e9 fb fe ff ff       	jmp    80100699 <cprintf+0x19>
8010079e:	e8 3d fc ff ff       	call   801003e0 <consputc.part.0>
      for(; *s; s++)
801007a3:	43                   	inc    %ebx
801007a4:	0f be 03             	movsbl (%ebx),%eax
801007a7:	84 c0                	test   %al,%al
801007a9:	75 ac                	jne    80100757 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007ab:	89 fb                	mov    %edi,%ebx
801007ad:	e9 28 ff ff ff       	jmp    801006da <cprintf+0x5a>
  if(panicked){
801007b2:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007b8:	85 ff                	test   %edi,%edi
801007ba:	0f 84 10 ff ff ff    	je     801006d0 <cprintf+0x50>
801007c0:	fa                   	cli    
    for(;;)
801007c1:	eb fe                	jmp    801007c1 <cprintf+0x141>
801007c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(panicked){
801007d0:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007d6:	85 c9                	test   %ecx,%ecx
801007d8:	74 06                	je     801007e0 <cprintf+0x160>
801007da:	fa                   	cli    
    for(;;)
801007db:	eb fe                	jmp    801007db <cprintf+0x15b>
801007dd:	8d 76 00             	lea    0x0(%esi),%esi
801007e0:	b8 25 00 00 00       	mov    $0x25,%eax
801007e5:	e8 f6 fb ff ff       	call   801003e0 <consputc.part.0>
  if(panicked){
801007ea:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801007f0:	85 d2                	test   %edx,%edx
801007f2:	74 2c                	je     80100820 <cprintf+0x1a0>
801007f4:	fa                   	cli    
    for(;;)
801007f5:	eb fe                	jmp    801007f5 <cprintf+0x175>
801007f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007fe:	66 90                	xchg   %ax,%ax
    release(&cons.lock);
80100800:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100807:	e8 44 3f 00 00       	call   80104750 <release>
}
8010080c:	e9 e2 fe ff ff       	jmp    801006f3 <cprintf+0x73>
    panic("null fmt");
80100811:	c7 04 24 7f 72 10 80 	movl   $0x8010727f,(%esp)
80100818:	e8 43 fb ff ff       	call   80100360 <panic>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
80100820:	89 f8                	mov    %edi,%eax
80100822:	e8 b9 fb ff ff       	call   801003e0 <consputc.part.0>
80100827:	e9 ae fe ff ff       	jmp    801006da <cprintf+0x5a>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100830 <consoleintr>:
{
80100830:	55                   	push   %ebp
80100831:	89 e5                	mov    %esp,%ebp
80100833:	57                   	push   %edi
80100834:	56                   	push   %esi
  int c, doprocdump = 0;
80100835:	31 f6                	xor    %esi,%esi
{
80100837:	53                   	push   %ebx
80100838:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&cons.lock);
8010083b:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
{
80100842:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100845:	e8 56 3e 00 00       	call   801046a0 <acquire>
  while((c = getc()) >= 0){
8010084a:	eb 17                	jmp    80100863 <consoleintr+0x33>
    switch(c){
8010084c:	83 fb 08             	cmp    $0x8,%ebx
8010084f:	0f 84 fb 00 00 00    	je     80100950 <consoleintr+0x120>
80100855:	83 fb 10             	cmp    $0x10,%ebx
80100858:	0f 85 22 01 00 00    	jne    80100980 <consoleintr+0x150>
8010085e:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100863:	ff d7                	call   *%edi
80100865:	85 c0                	test   %eax,%eax
80100867:	89 c3                	mov    %eax,%ebx
80100869:	0f 88 40 01 00 00    	js     801009af <consoleintr+0x17f>
    switch(c){
8010086f:	83 fb 15             	cmp    $0x15,%ebx
80100872:	74 7c                	je     801008f0 <consoleintr+0xc0>
80100874:	7e d6                	jle    8010084c <consoleintr+0x1c>
80100876:	83 fb 7f             	cmp    $0x7f,%ebx
80100879:	0f 84 d1 00 00 00    	je     80100950 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010087f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100884:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
8010088a:	89 c2                	mov    %eax,%edx
8010088c:	29 ca                	sub    %ecx,%edx
8010088e:	83 fa 7f             	cmp    $0x7f,%edx
80100891:	77 d0                	ja     80100863 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
80100893:	8d 48 01             	lea    0x1(%eax),%ecx
80100896:	83 e0 7f             	and    $0x7f,%eax
80100899:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008a5:	83 fb 0d             	cmp    $0xd,%ebx
801008a8:	0f 84 19 01 00 00    	je     801009c7 <consoleintr+0x197>
        input.buf[input.e++ % INPUT_BUF] = c;
801008ae:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008b4:	85 d2                	test   %edx,%edx
801008b6:	0f 85 16 01 00 00    	jne    801009d2 <consoleintr+0x1a2>
801008bc:	89 d8                	mov    %ebx,%eax
801008be:	e8 1d fb ff ff       	call   801003e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 fb 0a             	cmp    $0xa,%ebx
801008c6:	0f 84 2a 01 00 00    	je     801009f6 <consoleintr+0x1c6>
801008cc:	83 fb 04             	cmp    $0x4,%ebx
801008cf:	0f 84 21 01 00 00    	je     801009f6 <consoleintr+0x1c6>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 7a ff ff ff    	jne    80100863 <consoleintr+0x33>
801008e9:	e9 0d 01 00 00       	jmp    801009fb <consoleintr+0x1cb>
801008ee:	66 90                	xchg   %ax,%ax
      while(input.e != input.w &&
801008f0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008f5:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008fb:	0f 84 62 ff ff ff    	je     80100863 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100901:	48                   	dec    %eax
80100902:	89 c2                	mov    %eax,%edx
80100904:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100907:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010090e:	0f 84 4f ff ff ff    	je     80100863 <consoleintr+0x33>
        input.e--;
80100914:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100919:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010091e:	85 c0                	test   %eax,%eax
80100920:	74 0e                	je     80100930 <consoleintr+0x100>
80100922:	fa                   	cli    
    for(;;)
80100923:	eb fe                	jmp    80100923 <consoleintr+0xf3>
80100925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010092c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100930:	b8 00 01 00 00       	mov    $0x100,%eax
80100935:	e8 a6 fa ff ff       	call   801003e0 <consputc.part.0>
      while(input.e != input.w &&
8010093a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100945:	75 ba                	jne    80100901 <consoleintr+0xd1>
80100947:	e9 17 ff ff ff       	jmp    80100863 <consoleintr+0x33>
8010094c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100950:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100955:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010095b:	0f 84 02 ff ff ff    	je     80100863 <consoleintr+0x33>
  if(panicked){
80100961:	8b 1d 58 a5 10 80    	mov    0x8010a558,%ebx
        input.e--;
80100967:	48                   	dec    %eax
80100968:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096d:	85 db                	test   %ebx,%ebx
8010096f:	74 2f                	je     801009a0 <consoleintr+0x170>
80100971:	fa                   	cli    
    for(;;)
80100972:	eb fe                	jmp    80100972 <consoleintr+0x142>
80100974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100980:	85 db                	test   %ebx,%ebx
80100982:	0f 84 db fe ff ff    	je     80100863 <consoleintr+0x33>
80100988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010098f:	90                   	nop
80100990:	e9 ea fe ff ff       	jmp    8010087f <consoleintr+0x4f>
80100995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 36 fa ff ff       	call   801003e0 <consputc.part.0>
801009aa:	e9 b4 fe ff ff       	jmp    80100863 <consoleintr+0x33>
  release(&cons.lock);
801009af:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801009b6:	e8 95 3d 00 00       	call   80104750 <release>
  if(doprocdump) {
801009bb:	85 f6                	test   %esi,%esi
801009bd:	75 21                	jne    801009e0 <consoleintr+0x1b0>
}
801009bf:	83 c4 1c             	add    $0x1c,%esp
801009c2:	5b                   	pop    %ebx
801009c3:	5e                   	pop    %esi
801009c4:	5f                   	pop    %edi
801009c5:	5d                   	pop    %ebp
801009c6:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009c7:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ce:	85 d2                	test   %edx,%edx
801009d0:	74 1a                	je     801009ec <consoleintr+0x1bc>
801009d2:	fa                   	cli    
    for(;;)
801009d3:	eb fe                	jmp    801009d3 <consoleintr+0x1a3>
801009d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801009e0:	83 c4 1c             	add    $0x1c,%esp
801009e3:	5b                   	pop    %ebx
801009e4:	5e                   	pop    %esi
801009e5:	5f                   	pop    %edi
801009e6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009e7:	e9 54 38 00 00       	jmp    80104240 <procdump>
801009ec:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f1:	e8 ea f9 ff ff       	call   801003e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009f6:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009fb:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	e8 54 37 00 00       	call   80104160 <wakeup>
80100a0c:	e9 52 fe ff ff       	jmp    80100863 <consoleintr+0x33>
80100a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1f:	90                   	nop

80100a20 <consoleinit>:

void
consoleinit(void)
{
80100a20:	55                   	push   %ebp
  initlock(&cons.lock, "console");
80100a21:	b8 88 72 10 80       	mov    $0x80107288,%eax
{
80100a26:	89 e5                	mov    %esp,%ebp
80100a28:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a2f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100a36:	e8 f5 3a 00 00       	call   80104530 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
80100a3b:	b8 01 00 00 00       	mov    $0x1,%eax
  devsw[CONSOLE].write = consolewrite;
80100a40:	ba 10 06 10 80       	mov    $0x80100610,%edx
  cons.locking = 1;
80100a45:	a3 54 a5 10 80       	mov    %eax,0x8010a554

  ioapicenable(IRQ_KBD, 0);
80100a4a:	31 c0                	xor    %eax,%eax
  devsw[CONSOLE].read = consoleread;
80100a4c:	b9 70 02 10 80       	mov    $0x80100270,%ecx
  ioapicenable(IRQ_KBD, 0);
80100a51:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100a5c:	89 15 6c 09 11 80    	mov    %edx,0x8011096c
  devsw[CONSOLE].read = consoleread;
80100a62:	89 0d 68 09 11 80    	mov    %ecx,0x80110968
  ioapicenable(IRQ_KBD, 0);
80100a68:	e8 d3 1a 00 00       	call   80102540 <ioapicenable>
}
80100a6d:	c9                   	leave  
80100a6e:	c3                   	ret    
80100a6f:	90                   	nop

80100a70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	57                   	push   %edi
80100a74:	56                   	push   %esi
80100a75:	53                   	push   %ebx
80100a76:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a7c:	e8 7f 2f 00 00       	call   80103a00 <myproc>
80100a81:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a87:	e8 84 23 00 00       	call   80102e10 <begin_op>

  if((ip = namei(path)) == 0){
80100a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8f:	89 04 24             	mov    %eax,(%esp)
80100a92:	e8 d9 16 00 00       	call   80102170 <namei>
80100a97:	85 c0                	test   %eax,%eax
80100a99:	0f 84 39 03 00 00    	je     80100dd8 <exec+0x368>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a9f:	89 04 24             	mov    %eax,(%esp)
80100aa2:	89 c3                	mov    %eax,%ebx
80100aa4:	e8 57 0d 00 00       	call   80101800 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aa9:	b8 34 00 00 00       	mov    $0x34,%eax
80100aae:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100ab2:	31 c0                	xor    %eax,%eax
80100ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ab8:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac2:	89 1c 24             	mov    %ebx,(%esp)
80100ac5:	e8 26 10 00 00       	call   80101af0 <readi>
80100aca:	83 f8 34             	cmp    $0x34,%eax
80100acd:	74 21                	je     80100af0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100acf:	89 1c 24             	mov    %ebx,(%esp)
80100ad2:	e8 c9 0f 00 00       	call   80101aa0 <iunlockput>
    end_op();
80100ad7:	e8 a4 23 00 00       	call   80102e80 <end_op>
  }
  return -1;
80100adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ae1:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100ae7:	5b                   	pop    %ebx
80100ae8:	5e                   	pop    %esi
80100ae9:	5f                   	pop    %edi
80100aea:	5d                   	pop    %ebp
80100aeb:	c3                   	ret    
80100aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100af7:	45 4c 46 
80100afa:	75 d3                	jne    80100acf <exec+0x5f>
  if((pgdir = setupkvm()) == 0)
80100afc:	e8 4f 64 00 00       	call   80106f50 <setupkvm>
80100b01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b07:	85 c0                	test   %eax,%eax
80100b09:	74 c4                	je     80100acf <exec+0x5f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b0b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b12:	00 
80100b13:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b19:	0f 84 d4 02 00 00    	je     80100df3 <exec+0x383>
  sz = 0;
80100b1f:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b21:	31 ff                	xor    %edi,%edi
  sz = 0;
80100b23:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b29:	e9 99 00 00 00       	jmp    80100bc7 <exec+0x157>
80100b2e:	66 90                	xchg   %ax,%ax
    if(ph.type != ELF_PROG_LOAD)
80100b30:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b37:	75 7f                	jne    80100bb8 <exec+0x148>
    if(ph.memsz < ph.filesz)
80100b39:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b3f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b45:	0f 82 a4 00 00 00    	jb     80100bef <exec+0x17f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b4b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b51:	0f 82 98 00 00 00    	jb     80100bef <exec+0x17f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b57:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b5b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b61:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b65:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b6b:	89 04 24             	mov    %eax,(%esp)
80100b6e:	e8 ed 61 00 00       	call   80106d60 <allocuvm>
80100b73:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b79:	85 c0                	test   %eax,%eax
80100b7b:	74 72                	je     80100bef <exec+0x17f>
    if(ph.vaddr % PGSIZE != 0)
80100b7d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b83:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b88:	75 65                	jne    80100bef <exec+0x17f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8e:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100b94:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b98:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b9e:	89 54 24 10          	mov    %edx,0x10(%esp)
80100ba2:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100ba8:	89 04 24             	mov    %eax,(%esp)
80100bab:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100baf:	e8 dc 60 00 00       	call   80106c90 <loaduvm>
80100bb4:	85 c0                	test   %eax,%eax
80100bb6:	78 37                	js     80100bef <exec+0x17f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbf:	47                   	inc    %edi
80100bc0:	83 c6 20             	add    $0x20,%esi
80100bc3:	39 f8                	cmp    %edi,%eax
80100bc5:	7e 49                	jle    80100c10 <exec+0x1a0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc7:	89 74 24 08          	mov    %esi,0x8(%esp)
80100bcb:	b8 20 00 00 00       	mov    $0x20,%eax
80100bd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bd4:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bde:	89 1c 24             	mov    %ebx,(%esp)
80100be1:	e8 0a 0f 00 00       	call   80101af0 <readi>
80100be6:	83 f8 20             	cmp    $0x20,%eax
80100be9:	0f 84 41 ff ff ff    	je     80100b30 <exec+0xc0>
    freevm(pgdir);
80100bef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bf5:	89 04 24             	mov    %eax,(%esp)
80100bf8:	e8 d3 62 00 00       	call   80106ed0 <freevm>
  if(ip){
80100bfd:	e9 cd fe ff ff       	jmp    80100acf <exec+0x5f>
80100c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c10:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c16:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c1c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c22:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c28:	89 1c 24             	mov    %ebx,(%esp)
80100c2b:	e8 70 0e 00 00       	call   80101aa0 <iunlockput>
  end_op();
80100c30:	e8 4b 22 00 00       	call   80102e80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c35:	89 7c 24 04          	mov    %edi,0x4(%esp)
80100c39:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c3f:	89 74 24 08          	mov    %esi,0x8(%esp)
80100c43:	89 3c 24             	mov    %edi,(%esp)
80100c46:	e8 15 61 00 00       	call   80106d60 <allocuvm>
80100c4b:	85 c0                	test   %eax,%eax
80100c4d:	89 c6                	mov    %eax,%esi
80100c4f:	0f 84 9b 00 00 00    	je     80100cf0 <exec+0x280>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c55:	89 3c 24             	mov    %edi,(%esp)
80100c58:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c5e:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  for(argc = 0; argv[argc]; argc++) {
80100c64:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c66:	e8 95 63 00 00       	call   80107000 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c74:	8b 00                	mov    (%eax),%eax
80100c76:	85 c0                	test   %eax,%eax
80100c78:	0f 84 90 00 00 00    	je     80100d0e <exec+0x29e>
80100c7e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c84:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c8a:	eb 21                	jmp    80100cad <exec+0x23d>
80100c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ustack[3+argc] = sp;
80100c90:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c9a:	47                   	inc    %edi
    ustack[3+argc] = sp;
80100c9b:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ca1:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca4:	85 c0                	test   %eax,%eax
80100ca6:	74 60                	je     80100d08 <exec+0x298>
    if(argc >= MAXARG)
80100ca8:	83 ff 20             	cmp    $0x20,%edi
80100cab:	74 43                	je     80100cf0 <exec+0x280>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cad:	89 04 24             	mov    %eax,(%esp)
80100cb0:	e8 0b 3d 00 00       	call   801049c0 <strlen>
80100cb5:	f7 d0                	not    %eax
80100cb7:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cbc:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cbf:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc2:	89 04 24             	mov    %eax,(%esp)
80100cc5:	e8 f6 3c 00 00       	call   801049c0 <strlen>
80100cca:	40                   	inc    %eax
80100ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd2:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cd5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100cd9:	89 34 24             	mov    %esi,(%esp)
80100cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ce0:	e8 8b 64 00 00       	call   80107170 <copyout>
80100ce5:	85 c0                	test   %eax,%eax
80100ce7:	79 a7                	jns    80100c90 <exec+0x220>
80100ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100cf0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cf6:	89 04 24             	mov    %eax,(%esp)
80100cf9:	e8 d2 61 00 00       	call   80106ed0 <freevm>
  return -1;
80100cfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d03:	e9 d9 fd ff ff       	jmp    80100ae1 <exec+0x71>
80100d08:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  ustack[3+argc] = 0;
80100d12:	31 c9                	xor    %ecx,%ecx
  ustack[0] = 0xffffffff;  // fake return PC
80100d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ustack[3+argc] = 0;
80100d19:	89 8c bd 64 ff ff ff 	mov    %ecx,-0x9c(%ebp,%edi,4)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d20:	89 d9                	mov    %ebx,%ecx
  ustack[0] = 0xffffffff;  // fake return PC
80100d22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d28:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
  ustack[1] = argc;
80100d2f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d35:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d37:	83 c0 0c             	add    $0xc,%eax
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  sp -= (3+argc+1) * 4;
80100d3e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d50:	89 04 24             	mov    %eax,(%esp)
80100d53:	e8 18 64 00 00       	call   80107170 <copyout>
80100d58:	85 c0                	test   %eax,%eax
80100d5a:	78 94                	js     80100cf0 <exec+0x280>
  for(last=s=path; *s; s++)
80100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80100d5f:	8b 55 08             	mov    0x8(%ebp),%edx
80100d62:	0f b6 00             	movzbl (%eax),%eax
80100d65:	84 c0                	test   %al,%al
80100d67:	74 14                	je     80100d7d <exec+0x30d>
80100d69:	89 d1                	mov    %edx,%ecx
80100d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d6f:	90                   	nop
    if(*s == '/')
80100d70:	41                   	inc    %ecx
80100d71:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d73:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d76:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d79:	84 c0                	test   %al,%al
80100d7b:	75 f3                	jne    80100d70 <exec+0x300>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d7d:	89 54 24 04          	mov    %edx,0x4(%esp)
80100d81:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d87:	b8 10 00 00 00       	mov    $0x10,%eax
80100d8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d90:	89 f8                	mov    %edi,%eax
80100d92:	83 c0 6c             	add    $0x6c,%eax
80100d95:	89 04 24             	mov    %eax,(%esp)
80100d98:	e8 e3 3b 00 00       	call   80104980 <safestrcpy>
  curproc->pgdir = pgdir;
80100d9d:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100da3:	89 f8                	mov    %edi,%eax
80100da5:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100da8:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100daa:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dad:	89 c1                	mov    %eax,%ecx
80100daf:	8b 40 18             	mov    0x18(%eax),%eax
80100db2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100db8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dbb:	8b 41 18             	mov    0x18(%ecx),%eax
80100dbe:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc1:	89 0c 24             	mov    %ecx,(%esp)
80100dc4:	e8 37 5d 00 00       	call   80106b00 <switchuvm>
  freevm(oldpgdir);
80100dc9:	89 3c 24             	mov    %edi,(%esp)
80100dcc:	e8 ff 60 00 00       	call   80106ed0 <freevm>
  return 0;
80100dd1:	31 c0                	xor    %eax,%eax
80100dd3:	e9 09 fd ff ff       	jmp    80100ae1 <exec+0x71>
    end_op();
80100dd8:	e8 a3 20 00 00       	call   80102e80 <end_op>
    cprintf("exec: fail\n");
80100ddd:	c7 04 24 a1 72 10 80 	movl   $0x801072a1,(%esp)
80100de4:	e8 97 f8 ff ff       	call   80100680 <cprintf>
    return -1;
80100de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dee:	e9 ee fc ff ff       	jmp    80100ae1 <exec+0x71>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100df3:	31 ff                	xor    %edi,%edi
80100df5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dfa:	e9 29 fe ff ff       	jmp    80100c28 <exec+0x1b8>
80100dff:	90                   	nop

80100e00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e00:	55                   	push   %ebp
  initlock(&ftable.lock, "ftable");
80100e01:	b8 ad 72 10 80       	mov    $0x801072ad,%eax
{
80100e06:	89 e5                	mov    %esp,%ebp
80100e08:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e0f:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e16:	e8 15 37 00 00       	call   80104530 <initlock>
}
80100e1b:	c9                   	leave  
80100e1c:	c3                   	ret    
80100e1d:	8d 76 00             	lea    0x0(%esi),%esi

80100e20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e24:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e29:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100e2c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e33:	e8 68 38 00 00       	call   801046a0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e38:	eb 11                	jmp    80100e4b <filealloc+0x2b>
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e40:	83 c3 18             	add    $0x18,%ebx
80100e43:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e49:	74 25                	je     80100e70 <filealloc+0x50>
    if(f->ref == 0){
80100e4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e4e:	85 c0                	test   %eax,%eax
80100e50:	75 ee                	jne    80100e40 <filealloc+0x20>
      f->ref = 1;
80100e52:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e59:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e60:	e8 eb 38 00 00       	call   80104750 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e65:	83 c4 14             	add    $0x14,%esp
80100e68:	89 d8                	mov    %ebx,%eax
80100e6a:	5b                   	pop    %ebx
80100e6b:	5d                   	pop    %ebp
80100e6c:	c3                   	ret    
80100e6d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100e70:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  return 0;
80100e77:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e79:	e8 d2 38 00 00       	call   80104750 <release>
}
80100e7e:	83 c4 14             	add    $0x14,%esp
80100e81:	89 d8                	mov    %ebx,%eax
80100e83:	5b                   	pop    %ebx
80100e84:	5d                   	pop    %ebp
80100e85:	c3                   	ret    
80100e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e8d:	8d 76 00             	lea    0x0(%esi),%esi

80100e90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
80100e94:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100e97:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
{
80100e9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ea1:	e8 fa 37 00 00       	call   801046a0 <acquire>
  if(f->ref < 1)
80100ea6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ea9:	85 c0                	test   %eax,%eax
80100eab:	7e 18                	jle    80100ec5 <filedup+0x35>
    panic("filedup");
  f->ref++;
80100ead:	40                   	inc    %eax
80100eae:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eb1:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100eb8:	e8 93 38 00 00       	call   80104750 <release>
  return f;
}
80100ebd:	83 c4 14             	add    $0x14,%esp
80100ec0:	89 d8                	mov    %ebx,%eax
80100ec2:	5b                   	pop    %ebx
80100ec3:	5d                   	pop    %ebp
80100ec4:	c3                   	ret    
    panic("filedup");
80100ec5:	c7 04 24 b4 72 10 80 	movl   $0x801072b4,(%esp)
80100ecc:	e8 8f f4 ff ff       	call   80100360 <panic>
80100ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100edf:	90                   	nop

80100ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	83 ec 38             	sub    $0x38,%esp
80100ee6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100eec:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
{
80100ef3:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100ef6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&ftable.lock);
80100ef9:	e8 a2 37 00 00       	call   801046a0 <acquire>
  if(f->ref < 1)
80100efe:	8b 53 04             	mov    0x4(%ebx),%edx
80100f01:	85 d2                	test   %edx,%edx
80100f03:	0f 8e b4 00 00 00    	jle    80100fbd <fileclose+0xdd>
    panic("fileclose");
  if(--f->ref > 0){
80100f09:	4a                   	dec    %edx
80100f0a:	89 53 04             	mov    %edx,0x4(%ebx)
80100f0d:	75 41                	jne    80100f50 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f0f:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f13:	8b 3b                	mov    (%ebx),%edi
  f->ref = 0;
  f->type = FD_NONE;
80100f15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f1b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f1e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f24:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100f2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f2e:	e8 1d 38 00 00       	call   80104750 <release>

  if(ff.type == FD_PIPE)
80100f33:	83 ff 01             	cmp    $0x1,%edi
80100f36:	74 68                	je     80100fa0 <fileclose+0xc0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f38:	83 ff 02             	cmp    $0x2,%edi
80100f3b:	74 33                	je     80100f70 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f3d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100f40:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f43:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f46:	89 ec                	mov    %ebp,%esp
80100f48:	5d                   	pop    %ebp
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f50:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    release(&ftable.lock);
80100f53:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f60:	89 ec                	mov    %ebp,%esp
80100f62:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f63:	e9 e8 37 00 00       	jmp    80104750 <release>
80100f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
    begin_op();
80100f70:	e8 9b 1e 00 00       	call   80102e10 <begin_op>
    iput(ff.ip);
80100f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f78:	89 04 24             	mov    %eax,(%esp)
80100f7b:	e8 b0 09 00 00       	call   80101930 <iput>
}
80100f80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f86:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f89:	89 ec                	mov    %ebp,%esp
80100f8b:	5d                   	pop    %ebp
    end_op();
80100f8c:	e9 ef 1e 00 00       	jmp    80102e80 <end_op>
80100f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fa0:	89 34 24             	mov    %esi,(%esp)
80100fa3:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100fab:	e8 e0 25 00 00       	call   80103590 <pipeclose>
}
80100fb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100fb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100fb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100fb9:	89 ec                	mov    %ebp,%esp
80100fbb:	5d                   	pop    %ebp
80100fbc:	c3                   	ret    
    panic("fileclose");
80100fbd:	c7 04 24 bc 72 10 80 	movl   $0x801072bc,(%esp)
80100fc4:	e8 97 f3 ff ff       	call   80100360 <panic>
80100fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 14             	sub    $0x14,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	8b 43 10             	mov    0x10(%ebx),%eax
80100fe2:	89 04 24             	mov    %eax,(%esp)
80100fe5:	e8 16 08 00 00       	call   80101800 <ilock>
    stati(f->ip, st);
80100fea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ff1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ff4:	89 04 24             	mov    %eax,(%esp)
80100ff7:	e8 c4 0a 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
80100ffc:	8b 43 10             	mov    0x10(%ebx),%eax
80100fff:	89 04 24             	mov    %eax,(%esp)
80101002:	e8 d9 08 00 00       	call   801018e0 <iunlock>
    return 0;
  }
  return -1;
}
80101007:	83 c4 14             	add    $0x14,%esp
    return 0;
8010100a:	31 c0                	xor    %eax,%eax
}
8010100c:	5b                   	pop    %ebx
8010100d:	5d                   	pop    %ebp
8010100e:	c3                   	ret    
8010100f:	90                   	nop
80101010:	83 c4 14             	add    $0x14,%esp
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	5b                   	pop    %ebx
80101019:	5d                   	pop    %ebp
8010101a:	c3                   	ret    
8010101b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010101f:	90                   	nop

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	83 ec 38             	sub    $0x38,%esp
80101026:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010102f:	8b 75 0c             	mov    0xc(%ebp),%esi
80101032:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101035:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101038:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010103c:	0f 84 7e 00 00 00    	je     801010c0 <fileread+0xa0>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 03                	mov    (%ebx),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	74 57                	je     801010a0 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101049:	83 f8 02             	cmp    $0x2,%eax
8010104c:	75 79                	jne    801010c7 <fileread+0xa7>
    ilock(f->ip);
8010104e:	8b 43 10             	mov    0x10(%ebx),%eax
80101051:	89 04 24             	mov    %eax,(%esp)
80101054:	e8 a7 07 00 00       	call   80101800 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101059:	89 7c 24 0c          	mov    %edi,0xc(%esp)
8010105d:	8b 43 14             	mov    0x14(%ebx),%eax
80101060:	89 74 24 04          	mov    %esi,0x4(%esp)
80101064:	89 44 24 08          	mov    %eax,0x8(%esp)
80101068:	8b 43 10             	mov    0x10(%ebx),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 7d 0a 00 00       	call   80101af0 <readi>
80101073:	85 c0                	test   %eax,%eax
80101075:	7e 03                	jle    8010107a <fileread+0x5a>
      f->off += r;
80101077:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010107a:	8b 53 10             	mov    0x10(%ebx),%edx
8010107d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101080:	89 14 24             	mov    %edx,(%esp)
80101083:	e8 58 08 00 00       	call   801018e0 <iunlock>
    return r;
80101088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
8010108b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010108e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101091:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101094:	89 ec                	mov    %ebp,%esp
80101096:	5d                   	pop    %ebp
80101097:	c3                   	ret    
80101098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
}
801010a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
801010a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801010a9:	8b 7d fc             	mov    -0x4(%ebp),%edi
    return piperead(f->pipe, addr, n);
801010ac:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010af:	89 ec                	mov    %ebp,%esp
801010b1:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010b2:	e9 89 26 00 00       	jmp    80103740 <piperead>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
    return -1;
801010c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010c5:	eb c4                	jmp    8010108b <fileread+0x6b>
  panic("fileread");
801010c7:	c7 04 24 c6 72 10 80 	movl   $0x801072c6,(%esp)
801010ce:	e8 8d f2 ff ff       	call   80100360 <panic>
801010d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 2c             	sub    $0x2c,%esp
801010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010ec:	8b 7d 08             	mov    0x8(%ebp),%edi
801010ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010f5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
801010f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010fc:	0f 84 c5 00 00 00    	je     801011c7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101102:	8b 07                	mov    (%edi),%eax
80101104:	83 f8 01             	cmp    $0x1,%eax
80101107:	0f 84 c7 00 00 00    	je     801011d4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010110d:	83 f8 02             	cmp    $0x2,%eax
80101110:	0f 85 d0 00 00 00    	jne    801011e6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101119:	31 f6                	xor    %esi,%esi
    while(i < n){
8010111b:	85 c0                	test   %eax,%eax
8010111d:	7f 35                	jg     80101154 <filewrite+0x74>
8010111f:	e9 9c 00 00 00       	jmp    801011c0 <filewrite+0xe0>
80101124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010112b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010112f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101130:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101133:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
80101136:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
80101139:	89 0c 24             	mov    %ecx,(%esp)
8010113c:	e8 9f 07 00 00       	call   801018e0 <iunlock>
      end_op();
80101141:	e8 3a 1d 00 00       	call   80102e80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101146:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101149:	39 c3                	cmp    %eax,%ebx
8010114b:	75 67                	jne    801011b4 <filewrite+0xd4>
        panic("short filewrite");
      i += r;
8010114d:	01 de                	add    %ebx,%esi
    while(i < n){
8010114f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101152:	7e 6c                	jle    801011c0 <filewrite+0xe0>
      int n1 = n - i;
80101154:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101157:	b8 00 06 00 00       	mov    $0x600,%eax
8010115c:	29 f3                	sub    %esi,%ebx
      if(n1 > max)
8010115e:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101164:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101167:	e8 a4 1c 00 00       	call   80102e10 <begin_op>
      ilock(f->ip);
8010116c:	8b 47 10             	mov    0x10(%edi),%eax
8010116f:	89 04 24             	mov    %eax,(%esp)
80101172:	e8 89 06 00 00       	call   80101800 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101177:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010117b:	8b 47 14             	mov    0x14(%edi),%eax
8010117e:	89 44 24 08          	mov    %eax,0x8(%esp)
80101182:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101185:	01 f0                	add    %esi,%eax
80101187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010118b:	8b 47 10             	mov    0x10(%edi),%eax
8010118e:	89 04 24             	mov    %eax,(%esp)
80101191:	e8 8a 0a 00 00       	call   80101c20 <writei>
80101196:	85 c0                	test   %eax,%eax
80101198:	7f 96                	jg     80101130 <filewrite+0x50>
8010119a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      iunlock(f->ip);
8010119d:	8b 57 10             	mov    0x10(%edi),%edx
801011a0:	89 14 24             	mov    %edx,(%esp)
801011a3:	e8 38 07 00 00       	call   801018e0 <iunlock>
      end_op();
801011a8:	e8 d3 1c 00 00       	call   80102e80 <end_op>
      if(r < 0)
801011ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b0:	85 c0                	test   %eax,%eax
801011b2:	75 13                	jne    801011c7 <filewrite+0xe7>
        panic("short filewrite");
801011b4:	c7 04 24 cf 72 10 80 	movl   $0x801072cf,(%esp)
801011bb:	e8 a0 f1 ff ff       	call   80100360 <panic>
    }
    return i == n ? n : -1;
801011c0:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011c3:	89 f0                	mov    %esi,%eax
801011c5:	74 05                	je     801011cc <filewrite+0xec>
801011c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011cc:	83 c4 2c             	add    $0x2c,%esp
801011cf:	5b                   	pop    %ebx
801011d0:	5e                   	pop    %esi
801011d1:	5f                   	pop    %edi
801011d2:	5d                   	pop    %ebp
801011d3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011d4:	8b 47 0c             	mov    0xc(%edi),%eax
801011d7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011da:	83 c4 2c             	add    $0x2c,%esp
801011dd:	5b                   	pop    %ebx
801011de:	5e                   	pop    %esi
801011df:	5f                   	pop    %edi
801011e0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011e1:	e9 4a 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
801011e6:	c7 04 24 d5 72 10 80 	movl   $0x801072d5,(%esp)
801011ed:	e8 6e f1 ff ff       	call   80100360 <panic>
801011f2:	66 90                	xchg   %ax,%ax
801011f4:	66 90                	xchg   %ax,%ax
801011f6:	66 90                	xchg   %ax,%ax
801011f8:	66 90                	xchg   %ax,%ax
801011fa:	66 90                	xchg   %ax,%ax
801011fc:	66 90                	xchg   %ax,%ax
801011fe:	66 90                	xchg   %ax,%ax

80101200 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101200:	55                   	push   %ebp
80101201:	89 c1                	mov    %eax,%ecx
80101203:	89 e5                	mov    %esp,%ebp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101205:	89 d0                	mov    %edx,%eax
{
80101207:	56                   	push   %esi
80101208:	53                   	push   %ebx
80101209:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010120b:	c1 e8 0c             	shr    $0xc,%eax
{
8010120e:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101211:	89 0c 24             	mov    %ecx,(%esp)
80101214:	8b 15 d8 09 11 80    	mov    0x801109d8,%edx
8010121a:	01 d0                	add    %edx,%eax
8010121c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101220:	e8 ab ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101225:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101227:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010122a:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010122d:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101233:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101235:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
8010123a:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
  m = 1 << (bi % 8);
8010123f:	d3 e0                	shl    %cl,%eax
80101241:	89 c1                	mov    %eax,%ecx
  if((bp->data[bi/8] & m) == 0)
80101243:	85 c2                	test   %eax,%edx
80101245:	74 1f                	je     80101266 <bfree+0x66>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101247:	f6 d1                	not    %cl
80101249:	20 d1                	and    %dl,%cl
8010124b:	88 4c 1e 5c          	mov    %cl,0x5c(%esi,%ebx,1)
  log_write(bp);
8010124f:	89 34 24             	mov    %esi,(%esp)
80101252:	e8 59 1d 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101257:	89 34 24             	mov    %esi,(%esp)
8010125a:	e8 91 ef ff ff       	call   801001f0 <brelse>
}
8010125f:	83 c4 10             	add    $0x10,%esp
80101262:	5b                   	pop    %ebx
80101263:	5e                   	pop    %esi
80101264:	5d                   	pop    %ebp
80101265:	c3                   	ret    
    panic("freeing free block");
80101266:	c7 04 24 df 72 10 80 	movl   $0x801072df,(%esp)
8010126d:	e8 ee f0 ff ff       	call   80100360 <panic>
80101272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101280 <balloc>:
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	83 ec 2c             	sub    $0x2c,%esp
80101289:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010128c:	8b 35 c0 09 11 80    	mov    0x801109c0,%esi
80101292:	85 f6                	test   %esi,%esi
80101294:	0f 84 7e 00 00 00    	je     80101318 <balloc+0x98>
8010129a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012a4:	8b 1d d8 09 11 80    	mov    0x801109d8,%ebx
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	c1 f8 0c             	sar    $0xc,%eax
801012af:	01 d8                	add    %ebx,%eax
801012b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801012b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801012b8:	89 04 24             	mov    %eax,(%esp)
801012bb:	e8 10 ee ff ff       	call   801000d0 <bread>
801012c0:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012c2:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801012c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012ca:	31 c0                	xor    %eax,%eax
801012cc:	eb 2b                	jmp    801012f9 <balloc+0x79>
801012ce:	66 90                	xchg   %ax,%ax
      m = 1 << (bi % 8);
801012d0:	89 c1                	mov    %eax,%ecx
801012d2:	bf 01 00 00 00       	mov    $0x1,%edi
801012d7:	83 e1 07             	and    $0x7,%ecx
801012da:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012dc:	89 c1                	mov    %eax,%ecx
      m = 1 << (bi % 8);
801012de:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012e1:	c1 f9 03             	sar    $0x3,%ecx
801012e4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801012e9:	85 7d e4             	test   %edi,-0x1c(%ebp)
801012ec:	89 fa                	mov    %edi,%edx
801012ee:	74 40                	je     80101330 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012f0:	40                   	inc    %eax
801012f1:	46                   	inc    %esi
801012f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012f7:	74 05                	je     801012fe <balloc+0x7e>
801012f9:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012fc:	77 d2                	ja     801012d0 <balloc+0x50>
    brelse(bp);
801012fe:	89 1c 24             	mov    %ebx,(%esp)
80101301:	e8 ea ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101306:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
8010130d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101310:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
80101316:	77 89                	ja     801012a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101318:	c7 04 24 f2 72 10 80 	movl   $0x801072f2,(%esp)
8010131f:	e8 3c f0 ff ff       	call   80100360 <panic>
80101324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010132f:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
80101330:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80101334:	08 c2                	or     %al,%dl
80101336:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 6e 1c 00 00       	call   80102fb0 <log_write>
        brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010134a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010134d:	89 74 24 04          	mov    %esi,0x4(%esp)
80101351:	89 04 24             	mov    %eax,(%esp)
80101354:	e8 77 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101359:	ba 00 02 00 00       	mov    $0x200,%edx
8010135e:	31 c9                	xor    %ecx,%ecx
80101360:	89 54 24 08          	mov    %edx,0x8(%esp)
80101364:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  bp = bread(dev, bno);
80101368:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010136a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010136d:	89 04 24             	mov    %eax,(%esp)
80101370:	e8 2b 34 00 00       	call   801047a0 <memset>
  log_write(bp);
80101375:	89 1c 24             	mov    %ebx,(%esp)
80101378:	e8 33 1c 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010137d:	89 1c 24             	mov    %ebx,(%esp)
80101380:	e8 6b ee ff ff       	call   801001f0 <brelse>
}
80101385:	83 c4 2c             	add    $0x2c,%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
8010138f:	90                   	nop

80101390 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	89 d7                	mov    %edx,%edi
80101396:	56                   	push   %esi
80101397:	89 c6                	mov    %eax,%esi
80101399:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010139f:	83 ec 2c             	sub    $0x2c,%esp
  acquire(&icache.lock);
801013a2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801013a9:	e8 f2 32 00 00       	call   801046a0 <acquire>
  empty = 0;
801013ae:	31 c0                	xor    %eax,%eax
801013b0:	eb 20                	jmp    801013d2 <iget+0x42>
801013b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 33                	cmp    %esi,(%ebx)
801013c2:	74 7c                	je     80101440 <iget+0xb0>
801013c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013d0:	73 2e                	jae    80101400 <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013d5:	85 c9                	test   %ecx,%ecx
801013d7:	7f e7                	jg     801013c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013d9:	85 c0                	test   %eax,%eax
801013db:	75 e7                	jne    801013c4 <iget+0x34>
801013dd:	89 da                	mov    %ebx,%edx
801013df:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013e5:	85 c9                	test   %ecx,%ecx
801013e7:	75 7a                	jne    80101463 <iget+0xd3>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e9:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013ef:	89 d0                	mov    %edx,%eax
801013f1:	72 df                	jb     801013d2 <iget+0x42>
801013f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101400:	85 c0                	test   %eax,%eax
80101402:	74 77                	je     8010147b <iget+0xeb>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101404:	89 30                	mov    %esi,(%eax)
  ip->inum = inum;
80101406:	89 78 04             	mov    %edi,0x4(%eax)
  ip->ref = 1;
80101409:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101410:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101417:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
  ip->valid = 0;
8010141e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  release(&icache.lock);
80101421:	e8 2a 33 00 00       	call   80104750 <release>
80101426:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return ip;
}
80101429:	83 c4 2c             	add    $0x2c,%esp
8010142c:	5b                   	pop    %ebx
8010142d:	5e                   	pop    %esi
8010142e:	5f                   	pop    %edi
8010142f:	5d                   	pop    %ebp
80101430:	c3                   	ret    
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101440:	39 7b 04             	cmp    %edi,0x4(%ebx)
80101443:	0f 85 7b ff ff ff    	jne    801013c4 <iget+0x34>
      release(&icache.lock);
80101449:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101450:	41                   	inc    %ecx
80101451:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101454:	e8 f7 32 00 00       	call   80104750 <release>
}
80101459:	83 c4 2c             	add    $0x2c,%esp
      return ip;
8010145c:	89 d8                	mov    %ebx,%eax
}
8010145e:	5b                   	pop    %ebx
8010145f:	5e                   	pop    %esi
80101460:	5f                   	pop    %edi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101463:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101469:	73 10                	jae    8010147b <iget+0xeb>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010146b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010146e:	85 c9                	test   %ecx,%ecx
80101470:	0f 8f 4a ff ff ff    	jg     801013c0 <iget+0x30>
80101476:	e9 62 ff ff ff       	jmp    801013dd <iget+0x4d>
    panic("iget: no inodes");
8010147b:	c7 04 24 08 73 10 80 	movl   $0x80107308,(%esp)
80101482:	e8 d9 ee ff ff       	call   80100360 <panic>
80101487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148e:	66 90                	xchg   %ax,%ax

80101490 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	83 ec 38             	sub    $0x38,%esp
80101496:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101499:	83 fa 0b             	cmp    $0xb,%edx
{
8010149c:	89 c6                	mov    %eax,%esi
8010149e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801014a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(bn < NDIRECT){
801014a4:	0f 86 96 00 00 00    	jbe    80101540 <bmap+0xb0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014aa:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014ad:	83 fb 7f             	cmp    $0x7f,%ebx
801014b0:	0f 87 ab 00 00 00    	ja     80101561 <bmap+0xd1>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014b6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014bc:	8b 16                	mov    (%esi),%edx
801014be:	85 c0                	test   %eax,%eax
801014c0:	74 5e                	je     80101520 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801014c6:	89 14 24             	mov    %edx,(%esp)
801014c9:	e8 02 ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014ce:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014d2:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014d4:	8b 03                	mov    (%ebx),%eax
801014d6:	85 c0                	test   %eax,%eax
801014d8:	74 26                	je     80101500 <bmap+0x70>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014da:	89 3c 24             	mov    %edi,(%esp)
801014dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014e0:	e8 0b ed ff ff       	call   801001f0 <brelse>
    return addr;
801014e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  panic("bmap: out of range");
}
801014e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801014eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
801014ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
801014f1:	89 ec                	mov    %ebp,%esp
801014f3:	5d                   	pop    %ebp
801014f4:	c3                   	ret    
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
80101500:	8b 06                	mov    (%esi),%eax
80101502:	e8 79 fd ff ff       	call   80101280 <balloc>
80101507:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101509:	89 3c 24             	mov    %edi,(%esp)
      a[bn] = addr = balloc(ip->dev);
8010150c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
8010150f:	e8 9c 1a 00 00       	call   80102fb0 <log_write>
80101514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101517:	eb c1                	jmp    801014da <bmap+0x4a>
80101519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101520:	89 d0                	mov    %edx,%eax
80101522:	e8 59 fd ff ff       	call   80101280 <balloc>
80101527:	8b 16                	mov    (%esi),%edx
80101529:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010152f:	eb 91                	jmp    801014c2 <bmap+0x32>
80101531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101543:	8b 47 5c             	mov    0x5c(%edi),%eax
80101546:	85 c0                	test   %eax,%eax
80101548:	75 9e                	jne    801014e8 <bmap+0x58>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154a:	8b 06                	mov    (%esi),%eax
8010154c:	e8 2f fd ff ff       	call   80101280 <balloc>
80101551:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101554:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101557:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010155a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010155d:	89 ec                	mov    %ebp,%esp
8010155f:	5d                   	pop    %ebp
80101560:	c3                   	ret    
  panic("bmap: out of range");
80101561:	c7 04 24 18 73 10 80 	movl   $0x80107318,(%esp)
80101568:	e8 f3 ed ff ff       	call   80100360 <panic>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
  bp = bread(dev, 1);
80101571:	b8 01 00 00 00       	mov    $0x1,%eax
{
80101576:	89 e5                	mov    %esp,%ebp
80101578:	83 ec 18             	sub    $0x18,%esp
  bp = bread(dev, 1);
8010157b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010157f:	8b 45 08             	mov    0x8(%ebp),%eax
{
80101582:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80101585:	89 75 fc             	mov    %esi,-0x4(%ebp)
80101588:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010158b:	89 04 24             	mov    %eax,(%esp)
8010158e:	e8 3d eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101593:	ba 1c 00 00 00       	mov    $0x1c,%edx
80101598:	89 34 24             	mov    %esi,(%esp)
8010159b:	89 54 24 08          	mov    %edx,0x8(%esp)
  bp = bread(dev, 1);
8010159f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015a1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801015a8:	e8 b3 32 00 00       	call   80104860 <memmove>
}
801015ad:	8b 75 fc             	mov    -0x4(%ebp),%esi
  brelse(bp);
801015b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801015b3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801015b6:	89 ec                	mov    %ebp,%esp
801015b8:	5d                   	pop    %ebp
  brelse(bp);
801015b9:	e9 32 ec ff ff       	jmp    801001f0 <brelse>
801015be:	66 90                	xchg   %ax,%ax

801015c0 <iinit>:
{
801015c0:	55                   	push   %ebp
  initlock(&icache.lock, "icache");
801015c1:	b9 2b 73 10 80       	mov    $0x8010732b,%ecx
{
801015c6:	89 e5                	mov    %esp,%ebp
801015c8:	53                   	push   %ebx
801015c9:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801015ce:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801015d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801015d5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801015dc:	e8 4f 2f 00 00       	call   80104530 <initlock>
  for(i = 0; i < NINODE; i++) {
801015e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	89 1c 24             	mov    %ebx,(%esp)
801015f3:	ba 32 73 10 80       	mov    $0x80107332,%edx
801015f8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101602:	e8 e9 2d 00 00       	call   801043f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101607:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x30>
  readsb(dev, &sb);
8010160f:	b8 c0 09 11 80       	mov    $0x801109c0,%eax
80101614:	89 44 24 04          	mov    %eax,0x4(%esp)
80101618:	8b 45 08             	mov    0x8(%ebp),%eax
8010161b:	89 04 24             	mov    %eax,(%esp)
8010161e:	e8 4d ff ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101623:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101628:	c7 04 24 98 73 10 80 	movl   $0x80107398,(%esp)
8010162f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101633:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101638:	89 44 24 18          	mov    %eax,0x18(%esp)
8010163c:	a1 d0 09 11 80       	mov    0x801109d0,%eax
80101641:	89 44 24 14          	mov    %eax,0x14(%esp)
80101645:	a1 cc 09 11 80       	mov    0x801109cc,%eax
8010164a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010164e:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101653:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101657:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010165c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101660:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101665:	89 44 24 04          	mov    %eax,0x4(%esp)
80101669:	e8 12 f0 ff ff       	call   80100680 <cprintf>
}
8010166e:	83 c4 24             	add    $0x24,%esp
80101671:	5b                   	pop    %ebx
80101672:	5d                   	pop    %ebp
80101673:	c3                   	ret    
80101674:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010167f:	90                   	nop

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 2c             	sub    $0x2c,%esp
80101689:	0f bf 45 0c          	movswl 0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168d:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101694:	8b 75 08             	mov    0x8(%ebp),%esi
80101697:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010169a:	0f 86 91 00 00 00    	jbe    80101731 <ialloc+0xb1>
801016a0:	bf 01 00 00 00       	mov    $0x1,%edi
801016a5:	eb 1a                	jmp    801016c1 <ialloc+0x41>
801016a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ae:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016b0:	89 1c 24             	mov    %ebx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	47                   	inc    %edi
    brelse(bp);
801016b4:	e8 37 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
801016bf:	73 70                	jae    80101731 <ialloc+0xb1>
    bp = bread(dev, IBLOCK(inum, sb));
801016c1:	89 34 24             	mov    %esi,(%esp)
801016c4:	8b 0d d4 09 11 80    	mov    0x801109d4,%ecx
801016ca:	89 f8                	mov    %edi,%eax
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	01 c8                	add    %ecx,%eax
801016d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801016d5:	e8 f6 e9 ff ff       	call   801000d0 <bread>
801016da:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016dc:	89 f8                	mov    %edi,%eax
801016de:	83 e0 07             	and    $0x7,%eax
801016e1:	c1 e0 06             	shl    $0x6,%eax
801016e4:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016e8:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016ec:	75 c2                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016ee:	89 0c 24             	mov    %ecx,(%esp)
801016f1:	31 d2                	xor    %edx,%edx
801016f3:	b8 40 00 00 00       	mov    $0x40,%eax
801016f8:	89 54 24 04          	mov    %edx,0x4(%esp)
801016fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80101700:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101703:	e8 98 30 00 00       	call   801047a0 <memset>
      dip->type = type;
80101708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010170b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170e:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101711:	89 1c 24             	mov    %ebx,(%esp)
80101714:	e8 97 18 00 00       	call   80102fb0 <log_write>
      brelse(bp);
80101719:	89 1c 24             	mov    %ebx,(%esp)
8010171c:	e8 cf ea ff ff       	call   801001f0 <brelse>
}
80101721:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101724:	89 f0                	mov    %esi,%eax
}
80101726:	5b                   	pop    %ebx
      return iget(dev, inum);
80101727:	89 fa                	mov    %edi,%edx
}
80101729:	5e                   	pop    %esi
8010172a:	5f                   	pop    %edi
8010172b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172c:	e9 5f fc ff ff       	jmp    80101390 <iget>
  panic("ialloc: no inodes");
80101731:	c7 04 24 38 73 10 80 	movl   $0x80107338,(%esp)
80101738:	e8 23 ec ff ff       	call   80100360 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	83 ec 10             	sub    $0x10,%esp
80101748:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174b:	8b 15 d4 09 11 80    	mov    0x801109d4,%edx
80101751:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101754:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101757:	c1 e8 03             	shr    $0x3,%eax
8010175a:	01 d0                	add    %edx,%eax
8010175c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101760:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101763:	89 04 24             	mov    %eax,(%esp)
80101766:	e8 65 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
8010176b:	0f bf 53 f4          	movswl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176f:	b9 34 00 00 00       	mov    $0x34,%ecx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101774:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101776:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101779:	83 e0 07             	and    $0x7,%eax
8010177c:	c1 e0 06             	shl    $0x6,%eax
8010177f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101783:	66 89 10             	mov    %dx,(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101786:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101789:	0f bf 53 f6          	movswl -0xa(%ebx),%edx
8010178d:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101791:	0f bf 53 f8          	movswl -0x8(%ebx),%edx
80101795:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101799:	0f bf 53 fa          	movswl -0x6(%ebx),%edx
8010179d:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017a1:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017a4:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801017ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801017af:	89 04 24             	mov    %eax,(%esp)
801017b2:	e8 a9 30 00 00       	call   80104860 <memmove>
  log_write(bp);
801017b7:	89 34 24             	mov    %esi,(%esp)
801017ba:	e8 f1 17 00 00       	call   80102fb0 <log_write>
  brelse(bp);
801017bf:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c2:	83 c4 10             	add    $0x10,%esp
801017c5:	5b                   	pop    %ebx
801017c6:	5e                   	pop    %esi
801017c7:	5d                   	pop    %ebp
  brelse(bp);
801017c8:	e9 23 ea ff ff       	jmp    801001f0 <brelse>
801017cd:	8d 76 00             	lea    0x0(%esi),%esi

801017d0 <idup>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	53                   	push   %ebx
801017d4:	83 ec 14             	sub    $0x14,%esp
  acquire(&icache.lock);
801017d7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801017de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017e1:	e8 ba 2e 00 00       	call   801046a0 <acquire>
  ip->ref++;
801017e6:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
801017e9:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f0:	e8 5b 2f 00 00       	call   80104750 <release>
}
801017f5:	83 c4 14             	add    $0x14,%esp
801017f8:	89 d8                	mov    %ebx,%eax
801017fa:	5b                   	pop    %ebx
801017fb:	5d                   	pop    %ebp
801017fc:	c3                   	ret    
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <ilock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	83 ec 10             	sub    $0x10,%esp
80101808:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010180b:	85 db                	test   %ebx,%ebx
8010180d:	0f 84 be 00 00 00    	je     801018d1 <ilock+0xd1>
80101813:	8b 43 08             	mov    0x8(%ebx),%eax
80101816:	85 c0                	test   %eax,%eax
80101818:	0f 8e b3 00 00 00    	jle    801018d1 <ilock+0xd1>
  acquiresleep(&ip->lock);
8010181e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101821:	89 04 24             	mov    %eax,(%esp)
80101824:	e8 07 2c 00 00       	call   80104430 <acquiresleep>
  if(ip->valid == 0){
80101829:	8b 73 4c             	mov    0x4c(%ebx),%esi
8010182c:	85 f6                	test   %esi,%esi
8010182e:	74 10                	je     80101840 <ilock+0x40>
}
80101830:	83 c4 10             	add    $0x10,%esp
80101833:	5b                   	pop    %ebx
80101834:	5e                   	pop    %esi
80101835:	5d                   	pop    %ebp
80101836:	c3                   	ret    
80101837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183e:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101840:	8b 43 04             	mov    0x4(%ebx),%eax
80101843:	8b 15 d4 09 11 80    	mov    0x801109d4,%edx
80101849:	c1 e8 03             	shr    $0x3,%eax
8010184c:	01 d0                	add    %edx,%eax
8010184e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101852:	8b 03                	mov    (%ebx),%eax
80101854:	89 04 24             	mov    %eax,(%esp)
80101857:	e8 74 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	b9 34 00 00 00       	mov    $0x34,%ecx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101861:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101863:	8b 43 04             	mov    0x4(%ebx),%eax
80101866:	83 e0 07             	and    $0x7,%eax
80101869:	c1 e0 06             	shl    $0x6,%eax
8010186c:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101870:	0f bf 10             	movswl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101873:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101876:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010187a:	0f bf 50 f6          	movswl -0xa(%eax),%edx
8010187e:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101882:	0f bf 50 f8          	movswl -0x8(%eax),%edx
80101886:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010188a:	0f bf 50 fa          	movswl -0x6(%eax),%edx
8010188e:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101892:	8b 50 fc             	mov    -0x4(%eax),%edx
80101895:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010189f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801018a3:	89 04 24             	mov    %eax,(%esp)
801018a6:	e8 b5 2f 00 00       	call   80104860 <memmove>
    brelse(bp);
801018ab:	89 34 24             	mov    %esi,(%esp)
801018ae:	e8 3d e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018b3:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018b8:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018bf:	0f 85 6b ff ff ff    	jne    80101830 <ilock+0x30>
      panic("ilock: no type");
801018c5:	c7 04 24 50 73 10 80 	movl   $0x80107350,(%esp)
801018cc:	e8 8f ea ff ff       	call   80100360 <panic>
    panic("ilock");
801018d1:	c7 04 24 4a 73 10 80 	movl   $0x8010734a,(%esp)
801018d8:	e8 83 ea ff ff       	call   80100360 <panic>
801018dd:	8d 76 00             	lea    0x0(%esi),%esi

801018e0 <iunlock>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	83 ec 18             	sub    $0x18,%esp
801018e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801018e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018ef:	85 db                	test   %ebx,%ebx
801018f1:	74 27                	je     8010191a <iunlock+0x3a>
801018f3:	8d 73 0c             	lea    0xc(%ebx),%esi
801018f6:	89 34 24             	mov    %esi,(%esp)
801018f9:	e8 d2 2b 00 00       	call   801044d0 <holdingsleep>
801018fe:	85 c0                	test   %eax,%eax
80101900:	74 18                	je     8010191a <iunlock+0x3a>
80101902:	8b 43 08             	mov    0x8(%ebx),%eax
80101905:	85 c0                	test   %eax,%eax
80101907:	7e 11                	jle    8010191a <iunlock+0x3a>
  releasesleep(&ip->lock);
80101909:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010190c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010190f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80101912:	89 ec                	mov    %ebp,%esp
80101914:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101915:	e9 76 2b 00 00       	jmp    80104490 <releasesleep>
    panic("iunlock");
8010191a:	c7 04 24 5f 73 10 80 	movl   $0x8010735f,(%esp)
80101921:	e8 3a ea ff ff       	call   80100360 <panic>
80101926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192d:	8d 76 00             	lea    0x0(%esi),%esi

80101930 <iput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	83 ec 38             	sub    $0x38,%esp
80101936:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101939:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010193c:	89 7d fc             	mov    %edi,-0x4(%ebp)
8010193f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquiresleep(&ip->lock);
80101942:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101945:	89 3c 24             	mov    %edi,(%esp)
80101948:	e8 e3 2a 00 00       	call   80104430 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010194d:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101950:	85 d2                	test   %edx,%edx
80101952:	74 07                	je     8010195b <iput+0x2b>
80101954:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101959:	74 35                	je     80101990 <iput+0x60>
  releasesleep(&ip->lock);
8010195b:	89 3c 24             	mov    %edi,(%esp)
8010195e:	e8 2d 2b 00 00       	call   80104490 <releasesleep>
  acquire(&icache.lock);
80101963:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010196a:	e8 31 2d 00 00       	call   801046a0 <acquire>
  ip->ref--;
8010196f:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
80101972:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101979:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010197c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010197f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101982:	89 ec                	mov    %ebp,%esp
80101984:	5d                   	pop    %ebp
  release(&icache.lock);
80101985:	e9 c6 2d 00 00       	jmp    80104750 <release>
8010198a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101990:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101997:	e8 04 2d 00 00       	call   801046a0 <acquire>
    int r = ip->ref;
8010199c:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
8010199f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801019a6:	e8 a5 2d 00 00       	call   80104750 <release>
    if(r == 1){
801019ab:	4e                   	dec    %esi
801019ac:	75 ad                	jne    8010195b <iput+0x2b>
801019ae:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019b1:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019b7:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019ba:	89 cf                	mov    %ecx,%edi
801019bc:	eb 09                	jmp    801019c7 <iput+0x97>
801019be:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 fe                	cmp    %edi,%esi
801019c5:	74 19                	je     801019e0 <iput+0xb0>
    if(ip->addrs[i]){
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 2c f8 ff ff       	call   80101200 <bfree>
      ip->addrs[i] = 0;
801019d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019da:	eb e4                	jmp    801019c0 <iput+0x90>
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019e0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019e9:	85 c0                	test   %eax,%eax
801019eb:	75 33                	jne    80101a20 <iput+0xf0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801019ed:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019f4:	89 1c 24             	mov    %ebx,(%esp)
801019f7:	e8 44 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019fc:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101a02:	89 1c 24             	mov    %ebx,(%esp)
80101a05:	e8 36 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
80101a0a:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a11:	e9 45 ff ff ff       	jmp    8010195b <iput+0x2b>
80101a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 03                	mov    (%ebx),%eax
80101a26:	89 04 24             	mov    %eax,(%esp)
80101a29:	e8 a2 e6 ff ff       	call   801000d0 <bread>
80101a2e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a34:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a3a:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a3d:	89 cf                	mov    %ecx,%edi
80101a3f:	eb 16                	jmp    80101a57 <iput+0x127>
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4f:	90                   	nop
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 f7                	cmp    %esi,%edi
80101a55:	74 19                	je     80101a70 <iput+0x140>
      if(a[j])
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 9c f7 ff ff       	call   80101200 <bfree>
80101a64:	eb ea                	jmp    80101a50 <iput+0x120>
80101a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a73:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a76:	89 04 24             	mov    %eax,(%esp)
80101a79:	e8 72 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a7e:	8b 03                	mov    (%ebx),%eax
80101a80:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a86:	e8 75 f7 ff ff       	call   80101200 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a8b:	31 c0                	xor    %eax,%eax
80101a8d:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101a93:	e9 55 ff ff ff       	jmp    801019ed <iput+0xbd>
80101a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <iunlockput>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 14             	sub    $0x14,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aaa:	89 1c 24             	mov    %ebx,(%esp)
80101aad:	e8 2e fe ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101ab2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ab5:	83 c4 14             	add    $0x14,%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5d                   	pop    %ebp
  iput(ip);
80101aba:	e9 71 fe ff ff       	jmp    80101930 <iput>
80101abf:	90                   	nop

80101ac0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ac9:	8b 0a                	mov    (%edx),%ecx
80101acb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ace:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad4:	0f bf 4a 50          	movswl 0x50(%edx),%ecx
80101ad8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adb:	0f bf 4a 56          	movswl 0x56(%edx),%ecx
80101adf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae3:	8b 52 58             	mov    0x58(%edx),%edx
80101ae6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 2c             	sub    $0x2c,%esp
80101af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101afc:	8b 7d 08             	mov    0x8(%ebp),%edi
80101aff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101b02:	8b 45 10             	mov    0x10(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b05:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b0d:	8b 45 14             	mov    0x14(%ebp),%eax
80101b10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 c7 00 00 00    	je     80101be0 <readi+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 47 58             	mov    0x58(%edi),%eax
80101b1c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101b1f:	39 c1                	cmp    %eax,%ecx
80101b21:	0f 87 dd 00 00 00    	ja     80101c04 <readi+0x114>
80101b27:	89 ca                	mov    %ecx,%edx
80101b29:	31 f6                	xor    %esi,%esi
80101b2b:	03 55 e0             	add    -0x20(%ebp),%edx
80101b2e:	0f 82 d7 00 00 00    	jb     80101c0b <readi+0x11b>
80101b34:	85 f6                	test   %esi,%esi
80101b36:	0f 85 c8 00 00 00    	jne    80101c04 <readi+0x114>
    return -1;
  if(off + n > ip->size)
80101b3c:	39 d0                	cmp    %edx,%eax
80101b3e:	0f 82 8c 00 00 00    	jb     80101bd0 <readi+0xe0>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b47:	85 c0                	test   %eax,%eax
80101b49:	74 71                	je     80101bbc <readi+0xcc>
80101b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b53:	89 f8                	mov    %edi,%eax
80101b55:	89 da                	mov    %ebx,%edx
80101b57:	c1 ea 09             	shr    $0x9,%edx
80101b5a:	e8 31 f9 ff ff       	call   80101490 <bmap>
80101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b63:	8b 07                	mov    (%edi),%eax
80101b65:	89 04 24             	mov    %eax,(%esp)
80101b68:	e8 63 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b72:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 d8                	mov    %ebx,%eax
80101b79:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b7c:	89 55 d8             	mov    %edx,-0x28(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b84:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b86:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8e:	29 f3                	sub    %esi,%ebx
80101b90:	39 d9                	cmp    %ebx,%ecx
80101b92:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b95:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101b98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b9e:	89 0c 24             	mov    %ecx,(%esp)
80101ba1:	e8 ba 2c 00 00       	call   80104860 <memmove>
    brelse(bp);
80101ba6:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101ba9:	89 14 24             	mov    %edx,(%esp)
80101bac:	e8 3f e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb1:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bb4:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bb7:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101bba:	77 94                	ja     80101b50 <readi+0x60>
  }
  return n;
80101bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bbf:	83 c4 2c             	add    $0x2c,%esp
80101bc2:	5b                   	pop    %ebx
80101bc3:	5e                   	pop    %esi
80101bc4:	5f                   	pop    %edi
80101bc5:	5d                   	pop    %ebp
80101bc6:	c3                   	ret    
80101bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bce:	66 90                	xchg   %ax,%ax
    n = ip->size - off;
80101bd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101bd3:	29 d0                	sub    %edx,%eax
80101bd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101bd8:	e9 67 ff ff ff       	jmp    80101b44 <readi+0x54>
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 1a                	ja     80101c04 <readi+0x114>
80101bea:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0f                	je     80101c04 <readi+0x114>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bf8:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bfb:	83 c4 2c             	add    $0x2c,%esp
80101bfe:	5b                   	pop    %ebx
80101bff:	5e                   	pop    %esi
80101c00:	5f                   	pop    %edi
80101c01:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c02:	ff e0                	jmp    *%eax
      return -1;
80101c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c09:	eb b4                	jmp    80101bbf <readi+0xcf>
80101c0b:	be 01 00 00 00       	mov    $0x1,%esi
80101c10:	e9 1f ff ff ff       	jmp    80101b34 <readi+0x44>
80101c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 2c             	sub    $0x2c,%esp
80101c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2c:	8b 7d 08             	mov    0x8(%ebp),%edi
80101c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c35:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101c3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c3d:	8b 45 14             	mov    0x14(%ebp),%eax
80101c40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(ip->type == T_DEV){
80101c43:	0f 84 d7 00 00 00    	je     80101d20 <writei+0x100>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c49:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c4c:	39 77 58             	cmp    %esi,0x58(%edi)
80101c4f:	0f 82 0b 01 00 00    	jb     80101d60 <writei+0x140>
80101c55:	31 c0                	xor    %eax,%eax
80101c57:	03 75 dc             	add    -0x24(%ebp),%esi
80101c5a:	89 f2                	mov    %esi,%edx
80101c5c:	0f 82 05 01 00 00    	jb     80101d67 <writei+0x147>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c62:	85 c0                	test   %eax,%eax
80101c64:	0f 85 f6 00 00 00    	jne    80101d60 <writei+0x140>
80101c6a:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c70:	0f 87 ea 00 00 00    	ja     80101d60 <writei+0x140>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c7d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101c80:	85 c9                	test   %ecx,%ecx
80101c82:	0f 84 85 00 00 00    	je     80101d0d <writei+0xed>
80101c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c93:	89 f8                	mov    %edi,%eax
80101c95:	89 da                	mov    %ebx,%edx
80101c97:	c1 ea 09             	shr    $0x9,%edx
80101c9a:	e8 f1 f7 ff ff       	call   80101490 <bmap>
80101c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ca3:	8b 07                	mov    (%edi),%eax
80101ca5:	89 04 24             	mov    %eax,(%esp)
80101ca8:	e8 23 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cb0:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cb5:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb8:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cba:	89 d8                	mov    %ebx,%eax
80101cbc:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101cbf:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cc4:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cc6:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101cca:	89 04 24             	mov    %eax,(%esp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ccd:	29 d3                	sub    %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ccf:	8b 55 d8             	mov    -0x28(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd2:	39 d9                	cmp    %ebx,%ecx
80101cd4:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cdf:	e8 7c 2b 00 00       	call   80104860 <memmove>
    log_write(bp);
80101ce4:	89 34 24             	mov    %esi,(%esp)
80101ce7:	e8 c4 12 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101cec:	89 34 24             	mov    %esi,(%esp)
80101cef:	e8 fc e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf4:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cf7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cfa:	01 5d d8             	add    %ebx,-0x28(%ebp)
80101cfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d00:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
80101d03:	77 8b                	ja     80101c90 <writei+0x70>
  }

  if(n > 0 && off > ip->size){
80101d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d08:	3b 47 58             	cmp    0x58(%edi),%eax
80101d0b:	77 43                	ja     80101d50 <writei+0x130>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80101d10:	83 c4 2c             	add    $0x2c,%esp
80101d13:	5b                   	pop    %ebx
80101d14:	5e                   	pop    %esi
80101d15:	5f                   	pop    %edi
80101d16:	5d                   	pop    %ebp
80101d17:	c3                   	ret    
80101d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1f:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101d24:	66 83 f8 09          	cmp    $0x9,%ax
80101d28:	77 36                	ja     80101d60 <writei+0x140>
80101d2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101d31:	85 c0                	test   %eax,%eax
80101d33:	74 2b                	je     80101d60 <writei+0x140>
    return devsw[ip->major].write(ip, src, n);
80101d35:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101d38:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d3b:	83 c4 2c             	add    $0x2c,%esp
80101d3e:	5b                   	pop    %ebx
80101d3f:	5e                   	pop    %esi
80101d40:	5f                   	pop    %edi
80101d41:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d42:	ff e0                	jmp    *%eax
80101d44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
    ip->size = off;
80101d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d53:	89 47 58             	mov    %eax,0x58(%edi)
    iupdate(ip);
80101d56:	89 3c 24             	mov    %edi,(%esp)
80101d59:	e8 e2 f9 ff ff       	call   80101740 <iupdate>
80101d5e:	eb ad                	jmp    80101d0d <writei+0xed>
      return -1;
80101d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d65:	eb a9                	jmp    80101d10 <writei+0xf0>
80101d67:	b8 01 00 00 00       	mov    $0x1,%eax
80101d6c:	e9 f1 fe ff ff       	jmp    80101c62 <writei+0x42>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d80:	55                   	push   %ebp
  return strncmp(s, t, DIRSIZ);
80101d81:	b8 0e 00 00 00       	mov    $0xe,%eax
{
80101d86:	89 e5                	mov    %esp,%ebp
80101d88:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101d8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80101d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d92:	89 44 24 04          	mov    %eax,0x4(%esp)
80101d96:	8b 45 08             	mov    0x8(%ebp),%eax
80101d99:	89 04 24             	mov    %eax,(%esp)
80101d9c:	e8 2f 2b 00 00       	call   801048d0 <strncmp>
}
80101da1:	c9                   	leave  
80101da2:	c3                   	ret    
80101da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101db0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	83 ec 2c             	sub    $0x2c,%esp
80101db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101dc1:	0f 85 a4 00 00 00    	jne    80101e6b <dirlookup+0xbb>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101dc7:	8b 43 58             	mov    0x58(%ebx),%eax
80101dca:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dcd:	31 ff                	xor    %edi,%edi
80101dcf:	85 c0                	test   %eax,%eax
80101dd1:	74 59                	je     80101e2c <dirlookup+0x7c>
80101dd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101de0:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101de4:	b9 10 00 00 00       	mov    $0x10,%ecx
80101de9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101ded:	89 74 24 04          	mov    %esi,0x4(%esp)
80101df1:	89 1c 24             	mov    %ebx,(%esp)
80101df4:	e8 f7 fc ff ff       	call   80101af0 <readi>
80101df9:	83 f8 10             	cmp    $0x10,%eax
80101dfc:	75 61                	jne    80101e5f <dirlookup+0xaf>
      panic("dirlookup read");
    if(de.inum == 0)
80101dfe:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e03:	74 1f                	je     80101e24 <dirlookup+0x74>
  return strncmp(s, t, DIRSIZ);
80101e05:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e08:	ba 0e 00 00 00       	mov    $0xe,%edx
80101e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e11:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e14:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e18:	89 04 24             	mov    %eax,(%esp)
80101e1b:	e8 b0 2a 00 00       	call   801048d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e20:	85 c0                	test   %eax,%eax
80101e22:	74 1c                	je     80101e40 <dirlookup+0x90>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e24:	83 c7 10             	add    $0x10,%edi
80101e27:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e2a:	72 b4                	jb     80101de0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e2c:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101e2f:	31 c0                	xor    %eax,%eax
}
80101e31:	5b                   	pop    %ebx
80101e32:	5e                   	pop    %esi
80101e33:	5f                   	pop    %edi
80101e34:	5d                   	pop    %ebp
80101e35:	c3                   	ret    
80101e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3d:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101e40:	8b 45 10             	mov    0x10(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	74 05                	je     80101e4c <dirlookup+0x9c>
        *poff = off;
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e50:	8b 03                	mov    (%ebx),%eax
80101e52:	e8 39 f5 ff ff       	call   80101390 <iget>
}
80101e57:	83 c4 2c             	add    $0x2c,%esp
80101e5a:	5b                   	pop    %ebx
80101e5b:	5e                   	pop    %esi
80101e5c:	5f                   	pop    %edi
80101e5d:	5d                   	pop    %ebp
80101e5e:	c3                   	ret    
      panic("dirlookup read");
80101e5f:	c7 04 24 79 73 10 80 	movl   $0x80107379,(%esp)
80101e66:	e8 f5 e4 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101e6b:	c7 04 24 67 73 10 80 	movl   $0x80107367,(%esp)
80101e72:	e8 e9 e4 ff ff       	call   80100360 <panic>
80101e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7e:	66 90                	xchg   %ax,%ax

80101e80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	89 c3                	mov    %eax,%ebx
80101e88:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e94:	0f 84 66 01 00 00    	je     80102000 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e9a:	e8 61 1b 00 00       	call   80103a00 <myproc>
80101e9f:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ea2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ea9:	e8 f2 27 00 00       	call   801046a0 <acquire>
  ip->ref++;
80101eae:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101eb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101eb8:	e8 93 28 00 00       	call   80104750 <release>
  return ip;
80101ebd:	89 df                	mov    %ebx,%edi
80101ebf:	eb 10                	jmp    80101ed1 <namex+0x51>
80101ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop
    path++;
80101ed0:	47                   	inc    %edi
  while(*path == '/')
80101ed1:	0f b6 07             	movzbl (%edi),%eax
80101ed4:	3c 2f                	cmp    $0x2f,%al
80101ed6:	74 f8                	je     80101ed0 <namex+0x50>
  if(*path == 0)
80101ed8:	84 c0                	test   %al,%al
80101eda:	0f 84 f0 00 00 00    	je     80101fd0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101ee0:	0f b6 07             	movzbl (%edi),%eax
80101ee3:	84 c0                	test   %al,%al
80101ee5:	0f 84 05 01 00 00    	je     80101ff0 <namex+0x170>
80101eeb:	3c 2f                	cmp    $0x2f,%al
80101eed:	89 fb                	mov    %edi,%ebx
80101eef:	0f 84 fb 00 00 00    	je     80101ff0 <namex+0x170>
80101ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101f04:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80101f05:	3c 2f                	cmp    $0x2f,%al
80101f07:	74 04                	je     80101f0d <namex+0x8d>
80101f09:	84 c0                	test   %al,%al
80101f0b:	75 f3                	jne    80101f00 <namex+0x80>
  len = path - s;
80101f0d:	89 d8                	mov    %ebx,%eax
80101f0f:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101f11:	83 f8 0d             	cmp    $0xd,%eax
80101f14:	0f 8e 86 00 00 00    	jle    80101fa0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101f1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101f1e:	b8 0e 00 00 00       	mov    $0xe,%eax
    path++;
80101f23:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101f25:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f2c:	89 04 24             	mov    %eax,(%esp)
80101f2f:	e8 2c 29 00 00       	call   80104860 <memmove>
  while(*path == '/')
80101f34:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f37:	75 0d                	jne    80101f46 <namex+0xc6>
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f40:	47                   	inc    %edi
  while(*path == '/')
80101f41:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f44:	74 fa                	je     80101f40 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f46:	89 34 24             	mov    %esi,(%esp)
80101f49:	e8 b2 f8 ff ff       	call   80101800 <ilock>
    if(ip->type != T_DIR){
80101f4e:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f53:	0f 85 c7 00 00 00    	jne    80102020 <namex+0x1a0>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f59:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f5c:	85 db                	test   %ebx,%ebx
80101f5e:	74 09                	je     80101f69 <namex+0xe9>
80101f60:	80 3f 00             	cmpb   $0x0,(%edi)
80101f63:	0f 84 f7 00 00 00    	je     80102060 <namex+0x1e0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f69:	89 34 24             	mov    %esi,(%esp)
80101f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f6f:	31 c9                	xor    %ecx,%ecx
80101f71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101f75:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f79:	e8 32 fe ff ff       	call   80101db0 <dirlookup>
  iunlock(ip);
80101f7e:	89 34 24             	mov    %esi,(%esp)
    if((next = dirlookup(ip, name, 0)) == 0){
80101f81:	85 c0                	test   %eax,%eax
80101f83:	89 c3                	mov    %eax,%ebx
80101f85:	0f 84 b5 00 00 00    	je     80102040 <namex+0x1c0>
  iunlock(ip);
80101f8b:	e8 50 f9 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101f90:	89 34 24             	mov    %esi,(%esp)
80101f93:	89 de                	mov    %ebx,%esi
80101f95:	e8 96 f9 ff ff       	call   80101930 <iput>
  while(*path == '/')
80101f9a:	e9 32 ff ff ff       	jmp    80101ed1 <namex+0x51>
80101f9f:	90                   	nop
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101fa6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101fa9:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
    name[len] = 0;
80101fb4:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101fb6:	89 04 24             	mov    %eax,(%esp)
80101fb9:	e8 a2 28 00 00       	call   80104860 <memmove>
    name[len] = 0;
80101fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fc1:	c6 00 00             	movb   $0x0,(%eax)
80101fc4:	e9 6b ff ff ff       	jmp    80101f34 <namex+0xb4>
80101fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fd3:	85 d2                	test   %edx,%edx
80101fd5:	0f 85 a5 00 00 00    	jne    80102080 <namex+0x200>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fdb:	83 c4 2c             	add    $0x2c,%esp
80101fde:	89 f0                	mov    %esi,%eax
80101fe0:	5b                   	pop    %ebx
80101fe1:	5e                   	pop    %esi
80101fe2:	5f                   	pop    %edi
80101fe3:	5d                   	pop    %ebp
80101fe4:	c3                   	ret    
80101fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101ff0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ff3:	89 fb                	mov    %edi,%ebx
80101ff5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ff8:	31 c0                	xor    %eax,%eax
80101ffa:	eb ad                	jmp    80101fa9 <namex+0x129>
80101ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = iget(ROOTDEV, ROOTINO);
80102000:	ba 01 00 00 00       	mov    $0x1,%edx
80102005:	b8 01 00 00 00       	mov    $0x1,%eax
8010200a:	e8 81 f3 ff ff       	call   80101390 <iget>
8010200f:	89 c6                	mov    %eax,%esi
80102011:	e9 a7 fe ff ff       	jmp    80101ebd <namex+0x3d>
80102016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlock(ip);
80102020:	89 34 24             	mov    %esi,(%esp)
80102023:	e8 b8 f8 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80102028:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010202b:	31 f6                	xor    %esi,%esi
  iput(ip);
8010202d:	e8 fe f8 ff ff       	call   80101930 <iput>
}
80102032:	83 c4 2c             	add    $0x2c,%esp
80102035:	89 f0                	mov    %esi,%eax
80102037:	5b                   	pop    %ebx
80102038:	5e                   	pop    %esi
80102039:	5f                   	pop    %edi
8010203a:	5d                   	pop    %ebp
8010203b:	c3                   	ret    
8010203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102040:	e8 9b f8 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80102045:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102048:	31 f6                	xor    %esi,%esi
  iput(ip);
8010204a:	e8 e1 f8 ff ff       	call   80101930 <iput>
}
8010204f:	83 c4 2c             	add    $0x2c,%esp
80102052:	89 f0                	mov    %esi,%eax
80102054:	5b                   	pop    %ebx
80102055:	5e                   	pop    %esi
80102056:	5f                   	pop    %edi
80102057:	5d                   	pop    %ebp
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
80102060:	89 34 24             	mov    %esi,(%esp)
80102063:	e8 78 f8 ff ff       	call   801018e0 <iunlock>
}
80102068:	83 c4 2c             	add    $0x2c,%esp
8010206b:	89 f0                	mov    %esi,%eax
8010206d:	5b                   	pop    %ebx
8010206e:	5e                   	pop    %esi
8010206f:	5f                   	pop    %edi
80102070:	5d                   	pop    %ebp
80102071:	c3                   	ret    
80102072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iput(ip);
80102080:	89 34 24             	mov    %esi,(%esp)
    return 0;
80102083:	31 f6                	xor    %esi,%esi
    iput(ip);
80102085:	e8 a6 f8 ff ff       	call   80101930 <iput>
    return 0;
8010208a:	e9 4c ff ff ff       	jmp    80101fdb <namex+0x15b>
8010208f:	90                   	nop

80102090 <dirlink>:
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102096:	31 db                	xor    %ebx,%ebx
{
80102098:	83 ec 2c             	sub    $0x2c,%esp
  if((ip = dirlookup(dp, name, 0)) != 0){
8010209b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
{
8010209f:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
801020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a5:	89 3c 24             	mov    %edi,(%esp)
801020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ac:	e8 ff fc ff ff       	call   80101db0 <dirlookup>
801020b1:	85 c0                	test   %eax,%eax
801020b3:	0f 85 8e 00 00 00    	jne    80102147 <dirlink+0xb7>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020b9:	8b 5f 58             	mov    0x58(%edi),%ebx
801020bc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020bf:	85 db                	test   %ebx,%ebx
801020c1:	74 3a                	je     801020fd <dirlink+0x6d>
801020c3:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020c6:	31 db                	xor    %ebx,%ebx
801020c8:	eb 0e                	jmp    801020d8 <dirlink+0x48>
801020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020d0:	83 c3 10             	add    $0x10,%ebx
801020d3:	3b 5f 58             	cmp    0x58(%edi),%ebx
801020d6:	73 25                	jae    801020fd <dirlink+0x6d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801020dc:	b9 10 00 00 00       	mov    $0x10,%ecx
801020e1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801020e5:	89 74 24 04          	mov    %esi,0x4(%esp)
801020e9:	89 3c 24             	mov    %edi,(%esp)
801020ec:	e8 ff f9 ff ff       	call   80101af0 <readi>
801020f1:	83 f8 10             	cmp    $0x10,%eax
801020f4:	75 60                	jne    80102156 <dirlink+0xc6>
    if(de.inum == 0)
801020f6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020fb:	75 d3                	jne    801020d0 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
801020fd:	b8 0e 00 00 00       	mov    $0xe,%eax
80102102:	89 44 24 08          	mov    %eax,0x8(%esp)
80102106:	8b 45 0c             	mov    0xc(%ebp),%eax
80102109:	89 44 24 04          	mov    %eax,0x4(%esp)
8010210d:	8d 45 da             	lea    -0x26(%ebp),%eax
80102110:	89 04 24             	mov    %eax,(%esp)
80102113:	e8 08 28 00 00       	call   80104920 <strncpy>
  de.inum = inum;
80102118:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010211b:	ba 10 00 00 00       	mov    $0x10,%edx
80102120:	89 54 24 0c          	mov    %edx,0xc(%esp)
80102124:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102128:	89 74 24 04          	mov    %esi,0x4(%esp)
8010212c:	89 3c 24             	mov    %edi,(%esp)
  de.inum = inum;
8010212f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102133:	e8 e8 fa ff ff       	call   80101c20 <writei>
80102138:	83 f8 10             	cmp    $0x10,%eax
8010213b:	75 25                	jne    80102162 <dirlink+0xd2>
  return 0;
8010213d:	31 c0                	xor    %eax,%eax
}
8010213f:	83 c4 2c             	add    $0x2c,%esp
80102142:	5b                   	pop    %ebx
80102143:	5e                   	pop    %esi
80102144:	5f                   	pop    %edi
80102145:	5d                   	pop    %ebp
80102146:	c3                   	ret    
    iput(ip);
80102147:	89 04 24             	mov    %eax,(%esp)
8010214a:	e8 e1 f7 ff ff       	call   80101930 <iput>
    return -1;
8010214f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102154:	eb e9                	jmp    8010213f <dirlink+0xaf>
      panic("dirlink read");
80102156:	c7 04 24 88 73 10 80 	movl   $0x80107388,(%esp)
8010215d:	e8 fe e1 ff ff       	call   80100360 <panic>
    panic("dirlink");
80102162:	c7 04 24 c2 79 10 80 	movl   $0x801079c2,(%esp)
80102169:	e8 f2 e1 ff ff       	call   80100360 <panic>
8010216e:	66 90                	xchg   %ax,%ax

80102170 <namei>:

struct inode*
namei(char *path)
{
80102170:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102171:	31 d2                	xor    %edx,%edx
{
80102173:	89 e5                	mov    %esp,%ebp
80102175:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010217e:	e8 fd fc ff ff       	call   80101e80 <namex>
}
80102183:	c9                   	leave  
80102184:	c3                   	ret    
80102185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102190:	55                   	push   %ebp
  return namex(path, 1, name);
80102191:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102196:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010219e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010219f:	e9 dc fc ff ff       	jmp    80101e80 <namex>
801021a4:	66 90                	xchg   %ax,%ax
801021a6:	66 90                	xchg   %ax,%ax
801021a8:	66 90                	xchg   %ax,%ax
801021aa:	66 90                	xchg   %ax,%ax
801021ac:	66 90                	xchg   %ax,%ax
801021ae:	66 90                	xchg   %ax,%ax

801021b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	56                   	push   %esi
801021b4:	53                   	push   %ebx
801021b5:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
801021b8:	85 c0                	test   %eax,%eax
801021ba:	0f 84 a8 00 00 00    	je     80102268 <idestart+0xb8>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021c0:	8b 48 08             	mov    0x8(%eax),%ecx
801021c3:	89 c6                	mov    %eax,%esi
801021c5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
801021cb:	0f 87 8b 00 00 00    	ja     8010225c <idestart+0xac>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d1:	bb f7 01 00 00       	mov    $0x1f7,%ebx
801021d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021dd:	8d 76 00             	lea    0x0(%esi),%esi
801021e0:	89 da                	mov    %ebx,%edx
801021e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e3:	24 c0                	and    $0xc0,%al
801021e5:	3c 40                	cmp    $0x40,%al
801021e7:	75 f7                	jne    801021e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e9:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021ee:	31 c0                	xor    %eax,%eax
801021f0:	ee                   	out    %al,(%dx)
801021f1:	b0 01                	mov    $0x1,%al
801021f3:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021f8:	ee                   	out    %al,(%dx)
801021f9:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021fe:	88 c8                	mov    %cl,%al
80102200:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102201:	c1 f9 08             	sar    $0x8,%ecx
80102204:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102209:	89 c8                	mov    %ecx,%eax
8010220b:	ee                   	out    %al,(%dx)
8010220c:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102211:	31 c0                	xor    %eax,%eax
80102213:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102214:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102218:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221d:	c0 e0 04             	shl    $0x4,%al
80102220:	24 10                	and    $0x10,%al
80102222:	0c e0                	or     $0xe0,%al
80102224:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102225:	f6 06 04             	testb  $0x4,(%esi)
80102228:	75 16                	jne    80102240 <idestart+0x90>
8010222a:	b0 20                	mov    $0x20,%al
8010222c:	89 da                	mov    %ebx,%edx
8010222e:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010222f:	83 c4 10             	add    $0x10,%esp
80102232:	5b                   	pop    %ebx
80102233:	5e                   	pop    %esi
80102234:	5d                   	pop    %ebp
80102235:	c3                   	ret    
80102236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223d:	8d 76 00             	lea    0x0(%esi),%esi
80102240:	b0 30                	mov    $0x30,%al
80102242:	89 da                	mov    %ebx,%edx
80102244:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102245:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010224a:	83 c6 5c             	add    $0x5c,%esi
8010224d:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102252:	fc                   	cld    
80102253:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102255:	83 c4 10             	add    $0x10,%esp
80102258:	5b                   	pop    %ebx
80102259:	5e                   	pop    %esi
8010225a:	5d                   	pop    %ebp
8010225b:	c3                   	ret    
    panic("incorrect blockno");
8010225c:	c7 04 24 f4 73 10 80 	movl   $0x801073f4,(%esp)
80102263:	e8 f8 e0 ff ff       	call   80100360 <panic>
    panic("idestart");
80102268:	c7 04 24 eb 73 10 80 	movl   $0x801073eb,(%esp)
8010226f:	e8 ec e0 ff ff       	call   80100360 <panic>
80102274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <ideinit>:
{
80102280:	55                   	push   %ebp
  initlock(&idelock, "ide");
80102281:	ba 06 74 10 80       	mov    $0x80107406,%edx
{
80102286:	89 e5                	mov    %esp,%ebp
80102288:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
8010228b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010228f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102296:	e8 95 22 00 00       	call   80104530 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010229b:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801022a0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801022a7:	48                   	dec    %eax
801022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ac:	e8 8f 02 00 00       	call   80102540 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bd:	8d 76 00             	lea    0x0(%esi),%esi
801022c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c1:	24 c0                	and    $0xc0,%al
801022c3:	3c 40                	cmp    $0x40,%al
801022c5:	75 f9                	jne    801022c0 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c7:	b0 f0                	mov    $0xf0,%al
801022c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ce:	ee                   	out    %al,(%dx)
801022cf:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d4:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d9:	eb 08                	jmp    801022e3 <ideinit+0x63>
801022db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop
  for(i=0; i<1000; i++){
801022e0:	49                   	dec    %ecx
801022e1:	74 0f                	je     801022f2 <ideinit+0x72>
801022e3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022e4:	84 c0                	test   %al,%al
801022e6:	74 f8                	je     801022e0 <ideinit+0x60>
      havedisk1 = 1;
801022e8:	b8 01 00 00 00       	mov    $0x1,%eax
801022ed:	a3 60 a5 10 80       	mov    %eax,0x8010a560
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f2:	b0 e0                	mov    $0xe0,%al
801022f4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f9:	ee                   	out    %al,(%dx)
}
801022fa:	c9                   	leave  
801022fb:	c3                   	ret    
801022fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102300 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102309:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102310:	e8 8b 23 00 00       	call   801046a0 <acquire>

  if((b = idequeue) == 0){
80102315:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010231b:	85 db                	test   %ebx,%ebx
8010231d:	74 60                	je     8010237f <ideintr+0x7f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010231f:	8b 43 58             	mov    0x58(%ebx),%eax
80102322:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102327:	8b 33                	mov    (%ebx),%esi
80102329:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010232f:	75 30                	jne    80102361 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102331:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233d:	8d 76 00             	lea    0x0(%esi),%esi
80102340:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102341:	88 c1                	mov    %al,%cl
80102343:	80 e1 c0             	and    $0xc0,%cl
80102346:	80 f9 40             	cmp    $0x40,%cl
80102349:	75 f5                	jne    80102340 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010234b:	a8 21                	test   $0x21,%al
8010234d:	75 12                	jne    80102361 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010234f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102352:	b9 80 00 00 00       	mov    $0x80,%ecx
80102357:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010235c:	fc                   	cld    
8010235d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010235f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102361:	83 e6 fb             	and    $0xfffffffb,%esi
80102364:	83 ce 02             	or     $0x2,%esi
80102367:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102369:	89 1c 24             	mov    %ebx,(%esp)
8010236c:	e8 ef 1d 00 00       	call   80104160 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102371:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102376:	85 c0                	test   %eax,%eax
80102378:	74 05                	je     8010237f <ideintr+0x7f>
    idestart(idequeue);
8010237a:	e8 31 fe ff ff       	call   801021b0 <idestart>
    release(&idelock);
8010237f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102386:	e8 c5 23 00 00       	call   80104750 <release>

  release(&idelock);
}
8010238b:	83 c4 1c             	add    $0x1c,%esp
8010238e:	5b                   	pop    %ebx
8010238f:	5e                   	pop    %esi
80102390:	5f                   	pop    %edi
80102391:	5d                   	pop    %ebp
80102392:	c3                   	ret    
80102393:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	53                   	push   %ebx
801023a4:	83 ec 14             	sub    $0x14,%esp
801023a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801023ad:	89 04 24             	mov    %eax,(%esp)
801023b0:	e8 1b 21 00 00       	call   801044d0 <holdingsleep>
801023b5:	85 c0                	test   %eax,%eax
801023b7:	0f 84 c2 00 00 00    	je     8010247f <iderw+0xdf>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023bd:	8b 03                	mov    (%ebx),%eax
801023bf:	83 e0 06             	and    $0x6,%eax
801023c2:	83 f8 02             	cmp    $0x2,%eax
801023c5:	0f 84 a8 00 00 00    	je     80102473 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023cb:	8b 4b 04             	mov    0x4(%ebx),%ecx
801023ce:	85 c9                	test   %ecx,%ecx
801023d0:	74 0e                	je     801023e0 <iderw+0x40>
801023d2:	8b 15 60 a5 10 80    	mov    0x8010a560,%edx
801023d8:	85 d2                	test   %edx,%edx
801023da:	0f 84 87 00 00 00    	je     80102467 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023e0:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801023e7:	e8 b4 22 00 00       	call   801046a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ec:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801023f1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f8:	85 c0                	test   %eax,%eax
801023fa:	74 64                	je     80102460 <iderw+0xc0>
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102400:	89 c2                	mov    %eax,%edx
80102402:	8b 40 58             	mov    0x58(%eax),%eax
80102405:	85 c0                	test   %eax,%eax
80102407:	75 f7                	jne    80102400 <iderw+0x60>
80102409:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010240c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010240e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102414:	75 1b                	jne    80102431 <iderw+0x91>
80102416:	eb 38                	jmp    80102450 <iderw+0xb0>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80102420:	89 1c 24             	mov    %ebx,(%esp)
80102423:	b8 80 a5 10 80       	mov    $0x8010a580,%eax
80102428:	89 44 24 04          	mov    %eax,0x4(%esp)
8010242c:	e8 5f 1b 00 00       	call   80103f90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102431:	8b 03                	mov    (%ebx),%eax
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x80>
  }


  release(&idelock);
8010243b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102442:	83 c4 14             	add    $0x14,%esp
80102445:	5b                   	pop    %ebx
80102446:	5d                   	pop    %ebp
  release(&idelock);
80102447:	e9 04 23 00 00       	jmp    80104750 <release>
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 59 fd ff ff       	call   801021b0 <idestart>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102457:	eb d8                	jmp    80102431 <iderw+0x91>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102465:	eb a5                	jmp    8010240c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102467:	c7 04 24 35 74 10 80 	movl   $0x80107435,(%esp)
8010246e:	e8 ed de ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102473:	c7 04 24 20 74 10 80 	movl   $0x80107420,(%esp)
8010247a:	e8 e1 de ff ff       	call   80100360 <panic>
    panic("iderw: buf not locked");
8010247f:	c7 04 24 0a 74 10 80 	movl   $0x8010740a,(%esp)
80102486:	e8 d5 de ff ff       	call   80100360 <panic>
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102490:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102491:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
{
80102496:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102498:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010249d:	56                   	push   %esi
8010249e:	53                   	push   %ebx
8010249f:	83 ec 10             	sub    $0x10,%esp
  ioapic = (volatile struct ioapic*)IOAPIC;
801024a2:	a3 34 26 11 80       	mov    %eax,0x80112634
  ioapic->reg = reg;
801024a7:	89 15 00 00 c0 fe    	mov    %edx,0xfec00000
  return ioapic->data;
801024ad:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024b3:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024c9:	c1 e8 10             	shr    $0x10,%eax
801024cc:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024cf:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801024d2:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024d5:	39 c2                	cmp    %eax,%edx
801024d7:	74 12                	je     801024eb <ioapicinit+0x5b>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024d9:	c7 04 24 54 74 10 80 	movl   $0x80107454,(%esp)
801024e0:	e8 9b e1 ff ff       	call   80100680 <cprintf>
801024e5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024eb:	83 c6 21             	add    $0x21,%esi
{
801024ee:	ba 10 00 00 00       	mov    $0x10,%edx
801024f3:	b8 20 00 00 00       	mov    $0x20,%eax
801024f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop
  ioapic->reg = reg;
80102500:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102502:	89 c3                	mov    %eax,%ebx
80102504:	40                   	inc    %eax
  ioapic->data = data;
80102505:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010250b:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102511:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102514:	8d 5a 01             	lea    0x1(%edx),%ebx
80102517:	83 c2 02             	add    $0x2,%edx
8010251a:	89 19                	mov    %ebx,(%ecx)
  for(i = 0; i <= maxintr; i++){
8010251c:	39 f0                	cmp    %esi,%eax
  ioapic->data = data;
8010251e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102524:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010252b:	75 d3                	jne    80102500 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	5b                   	pop    %ebx
80102531:	5e                   	pop    %esi
80102532:	5d                   	pop    %ebp
80102533:	c3                   	ret    
80102534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010253f:	90                   	nop

80102540 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102540:	55                   	push   %ebp
  ioapic->reg = reg;
80102541:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102547:	89 e5                	mov    %esp,%ebp
80102549:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010254c:	8d 50 20             	lea    0x20(%eax),%edx
8010254f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102553:	89 01                	mov    %eax,(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102555:	40                   	inc    %eax
  ioapic->data = data;
80102556:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010255c:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102562:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102564:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102569:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010256c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010256f:	5d                   	pop    %ebp
80102570:	c3                   	ret    
80102571:	66 90                	xchg   %ax,%ax
80102573:	66 90                	xchg   %ax,%ax
80102575:	66 90                	xchg   %ax,%ax
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	83 ec 14             	sub    $0x14,%esp
80102587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010258a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102590:	75 7f                	jne    80102611 <kfree+0x91>
80102592:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102598:	72 77                	jb     80102611 <kfree+0x91>
8010259a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025a5:	77 6a                	ja     80102611 <kfree+0x91>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025a7:	89 1c 24             	mov    %ebx,(%esp)
801025aa:	ba 00 10 00 00       	mov    $0x1000,%edx
801025af:	b9 01 00 00 00       	mov    $0x1,%ecx
801025b4:	89 54 24 08          	mov    %edx,0x8(%esp)
801025b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801025bc:	e8 df 21 00 00       	call   801047a0 <memset>

  if(kmem.use_lock)
801025c1:	a1 74 26 11 80       	mov    0x80112674,%eax
801025c6:	85 c0                	test   %eax,%eax
801025c8:	75 26                	jne    801025f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025ca:	a1 78 26 11 80       	mov    0x80112678,%eax
801025cf:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801025d1:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801025d7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025dc:	85 c0                	test   %eax,%eax
801025de:	75 20                	jne    80102600 <kfree+0x80>
    release(&kmem.lock);
}
801025e0:	83 c4 14             	add    $0x14,%esp
801025e3:	5b                   	pop    %ebx
801025e4:	5d                   	pop    %ebp
801025e5:	c3                   	ret    
801025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ed:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801025f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801025f7:	e8 a4 20 00 00       	call   801046a0 <acquire>
801025fc:	eb cc                	jmp    801025ca <kfree+0x4a>
801025fe:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102600:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102607:	83 c4 14             	add    $0x14,%esp
8010260a:	5b                   	pop    %ebx
8010260b:	5d                   	pop    %ebp
    release(&kmem.lock);
8010260c:	e9 3f 21 00 00       	jmp    80104750 <release>
    panic("kfree");
80102611:	c7 04 24 86 74 10 80 	movl   $0x80107486,(%esp)
80102618:	e8 43 dd ff ff       	call   80100360 <panic>
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <freerange>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102628:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010262b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010262e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102634:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102640:	39 de                	cmp    %ebx,%esi
80102642:	72 24                	jb     80102668 <freerange+0x48>
80102644:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop
    kfree(p);
80102650:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265c:	89 04 24             	mov    %eax,(%esp)
8010265f:	e8 1c ff ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102664:	39 f3                	cmp    %esi,%ebx
80102666:	76 e8                	jbe    80102650 <freerange+0x30>
}
80102668:	83 c4 10             	add    $0x10,%esp
8010266b:	5b                   	pop    %ebx
8010266c:	5e                   	pop    %esi
8010266d:	5d                   	pop    %ebp
8010266e:	c3                   	ret    
8010266f:	90                   	nop

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
  initlock(&kmem.lock, "kmem");
80102671:	b8 8c 74 10 80       	mov    $0x8010748c,%eax
{
80102676:	89 e5                	mov    %esp,%ebp
80102678:	56                   	push   %esi
80102679:	53                   	push   %ebx
8010267a:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010267d:	89 44 24 04          	mov    %eax,0x4(%esp)
{
80102681:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102684:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010268b:	e8 a0 1e 00 00       	call   80104530 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102690:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102693:	31 d2                	xor    %edx,%edx
80102695:	89 15 74 26 11 80    	mov    %edx,0x80112674
  p = (char*)PGROUNDUP((uint)vstart);
8010269b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ad:	39 de                	cmp    %ebx,%esi
801026af:	72 27                	jb     801026d8 <kinit1+0x68>
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    kfree(p);
801026c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026cc:	89 04 24             	mov    %eax,(%esp)
801026cf:	e8 ac fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d4:	39 de                	cmp    %ebx,%esi
801026d6:	73 e8                	jae    801026c0 <kinit1+0x50>
}
801026d8:	83 c4 10             	add    $0x10,%esp
801026db:	5b                   	pop    %ebx
801026dc:	5e                   	pop    %esi
801026dd:	5d                   	pop    %ebp
801026de:	c3                   	ret    
801026df:	90                   	nop

801026e0 <kinit2>:
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx
801026e5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801026e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026ee:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102700:	39 de                	cmp    %ebx,%esi
80102702:	72 24                	jb     80102728 <kinit2+0x48>
80102704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
    kfree(p);
80102710:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102716:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010271c:	89 04 24             	mov    %eax,(%esp)
8010271f:	e8 5c fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102724:	39 de                	cmp    %ebx,%esi
80102726:	73 e8                	jae    80102710 <kinit2+0x30>
  kmem.use_lock = 1;
80102728:	b8 01 00 00 00       	mov    $0x1,%eax
8010272d:	a3 74 26 11 80       	mov    %eax,0x80112674
}
80102732:	83 c4 10             	add    $0x10,%esp
80102735:	5b                   	pop    %ebx
80102736:	5e                   	pop    %esi
80102737:	5d                   	pop    %ebp
80102738:	c3                   	ret    
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102740 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102740:	a1 74 26 11 80       	mov    0x80112674,%eax
80102745:	85 c0                	test   %eax,%eax
80102747:	75 27                	jne    80102770 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102749:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010274e:	85 c0                	test   %eax,%eax
80102750:	74 0e                	je     80102760 <kalloc+0x20>
    kmem.freelist = r->next;
80102752:	8b 10                	mov    (%eax),%edx
80102754:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010275a:	c3                   	ret    
8010275b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010275f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102760:	c3                   	ret    
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 28             	sub    $0x28,%esp
    acquire(&kmem.lock);
80102776:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010277d:	e8 1e 1f 00 00       	call   801046a0 <acquire>
  r = kmem.freelist;
80102782:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102787:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010278d:	85 c0                	test   %eax,%eax
8010278f:	74 08                	je     80102799 <kalloc+0x59>
    kmem.freelist = r->next;
80102791:	8b 08                	mov    (%eax),%ecx
80102793:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102799:	85 d2                	test   %edx,%edx
8010279b:	74 12                	je     801027af <kalloc+0x6f>
    release(&kmem.lock);
8010279d:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027a7:	e8 a4 1f 00 00       	call   80104750 <release>
  return (char*)r;
801027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027af:	c9                   	leave  
801027b0:	c3                   	ret    
801027b1:	66 90                	xchg   %ax,%ax
801027b3:	66 90                	xchg   %ax,%ax
801027b5:	66 90                	xchg   %ax,%ax
801027b7:	66 90                	xchg   %ax,%ax
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c0:	ba 64 00 00 00       	mov    $0x64,%edx
801027c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027c6:	24 01                	and    $0x1,%al
801027c8:	0f 84 c2 00 00 00    	je     80102890 <kbdgetc+0xd0>
{
801027ce:	55                   	push   %ebp
801027cf:	ba 60 00 00 00       	mov    $0x60,%edx
801027d4:	89 e5                	mov    %esp,%ebp
801027d6:	53                   	push   %ebx
801027d7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
801027d8:	3c e0                	cmp    $0xe0,%al
801027da:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  data = inb(KBDATAP);
801027e0:	0f b6 d0             	movzbl %al,%edx
  if(data == 0xE0){
801027e3:	74 5b                	je     80102840 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801027e5:	89 d9                	mov    %ebx,%ecx
801027e7:	83 e1 40             	and    $0x40,%ecx
801027ea:	84 c0                	test   %al,%al
801027ec:	78 62                	js     80102850 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027ee:	85 c9                	test   %ecx,%ecx
801027f0:	74 08                	je     801027fa <kbdgetc+0x3a>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027f2:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
801027f4:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027f7:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801027fa:	0f b6 8a c0 75 10 80 	movzbl -0x7fef8a40(%edx),%ecx
  shift ^= togglecode[data];
80102801:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
  shift |= shiftcode[data];
80102808:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010280a:	31 c1                	xor    %eax,%ecx
8010280c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102812:	89 c8                	mov    %ecx,%eax
80102814:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102817:	f6 c1 08             	test   $0x8,%cl
  c = charcode[shift & (CTL | SHIFT)][data];
8010281a:	8b 04 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%eax
80102821:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102825:	74 13                	je     8010283a <kbdgetc+0x7a>
    if('a' <= c && c <= 'z')
80102827:	8d 50 9f             	lea    -0x61(%eax),%edx
8010282a:	83 fa 19             	cmp    $0x19,%edx
8010282d:	76 51                	jbe    80102880 <kbdgetc+0xc0>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
8010282f:	8d 50 bf             	lea    -0x41(%eax),%edx
80102832:	83 fa 19             	cmp    $0x19,%edx
80102835:	77 03                	ja     8010283a <kbdgetc+0x7a>
      c += 'a' - 'A';
80102837:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102840:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102843:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102845:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010284b:	5b                   	pop    %ebx
8010284c:	5d                   	pop    %ebp
8010284d:	c3                   	ret    
8010284e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102850:	85 c9                	test   %ecx,%ecx
80102852:	75 05                	jne    80102859 <kbdgetc+0x99>
80102854:	24 7f                	and    $0x7f,%al
80102856:	0f b6 d0             	movzbl %al,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102859:	0f b6 82 c0 75 10 80 	movzbl -0x7fef8a40(%edx),%eax
80102860:	0c 40                	or     $0x40,%al
80102862:	0f b6 c8             	movzbl %al,%ecx
    return 0;
80102865:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102867:	f7 d1                	not    %ecx
80102869:	21 d9                	and    %ebx,%ecx
}
8010286b:	5b                   	pop    %ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010286c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102872:	5d                   	pop    %ebp
80102873:	c3                   	ret    
80102874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
80102880:	5b                   	pop    %ebx
      c += 'A' - 'a';
80102881:	83 e8 20             	sub    $0x20,%eax
}
80102884:	5d                   	pop    %ebp
80102885:	c3                   	ret    
80102886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80102890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102895:	c3                   	ret    
80102896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289d:	8d 76 00             	lea    0x0(%esi),%esi

801028a0 <kbdintr>:

void
kbdintr(void)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801028a6:	c7 04 24 c0 27 10 80 	movl   $0x801027c0,(%esp)
801028ad:	e8 7e df ff ff       	call   80100830 <consoleintr>
}
801028b2:	c9                   	leave  
801028b3:	c3                   	ret    
801028b4:	66 90                	xchg   %ax,%ax
801028b6:	66 90                	xchg   %ax,%ax
801028b8:	66 90                	xchg   %ax,%ax
801028ba:	66 90                	xchg   %ax,%ax
801028bc:	66 90                	xchg   %ax,%ax
801028be:	66 90                	xchg   %ax,%ax

801028c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	0f 84 c9 00 00 00    	je     80102996 <lapicinit+0xd6>
  lapic[index] = value;
801028cd:	ba 3f 01 00 00       	mov    $0x13f,%edx
801028d2:	b9 0b 00 00 00       	mov    $0xb,%ecx
801028d7:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e0:	89 88 e0 03 00 00    	mov    %ecx,0x3e0(%eax)
801028e6:	b9 80 96 98 00       	mov    $0x989680,%ecx
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ee:	ba 20 00 02 00       	mov    $0x20020,%edx
801028f3:	89 90 20 03 00 00    	mov    %edx,0x320(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f9:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fc:	89 88 80 03 00 00    	mov    %ecx,0x380(%eax)
80102902:	b9 00 00 01 00       	mov    $0x10000,%ecx
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010290f:	89 90 50 03 00 00    	mov    %edx,0x350(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102915:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102918:	89 88 60 03 00 00    	mov    %ecx,0x360(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010291e:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102921:	8b 50 30             	mov    0x30(%eax),%edx
80102924:	c1 ea 10             	shr    $0x10,%edx
80102927:	f6 c2 fc             	test   $0xfc,%dl
8010292a:	75 74                	jne    801029a0 <lapicinit+0xe0>
  lapic[index] = value;
8010292c:	b9 33 00 00 00       	mov    $0x33,%ecx
80102931:	89 88 70 03 00 00    	mov    %ecx,0x370(%eax)
80102937:	31 c9                	xor    %ecx,%ecx
  lapic[ID];  // wait for write to finish, by reading
80102939:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293c:	31 d2                	xor    %edx,%edx
8010293e:	89 90 80 02 00 00    	mov    %edx,0x280(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	89 88 80 02 00 00    	mov    %ecx,0x280(%eax)
8010294d:	31 c9                	xor    %ecx,%ecx
  lapic[ID];  // wait for write to finish, by reading
8010294f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102952:	31 d2                	xor    %edx,%edx
80102954:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295d:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102963:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102966:	ba 00 85 08 00       	mov    $0x88500,%edx
8010296b:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102971:	8b 50 20             	mov    0x20(%eax),%edx
80102974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102980:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102986:	f6 c6 10             	test   $0x10,%dh
80102989:	75 f5                	jne    80102980 <lapicinit+0xc0>
  lapic[index] = value;
8010298b:	31 d2                	xor    %edx,%edx
8010298d:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102996:	c3                   	ret    
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax
  lapic[index] = value;
801029a0:	b9 00 00 01 00       	mov    $0x10000,%ecx
801029a5:	89 88 40 03 00 00    	mov    %ecx,0x340(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ab:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ae:	e9 79 ff ff ff       	jmp    8010292c <lapicinit+0x6c>
801029b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029c0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	74 07                	je     801029d0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029c9:	8b 40 20             	mov    0x20(%eax),%eax
801029cc:	c1 e8 18             	shr    $0x18,%eax
801029cf:	c3                   	ret    
    return 0;
801029d0:	31 c0                	xor    %eax,%eax
}
801029d2:	c3                   	ret    
801029d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	74 0b                	je     801029f4 <lapiceoi+0x14>
  lapic[index] = value;
801029e9:	31 d2                	xor    %edx,%edx
801029eb:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f1:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029f4:	c3                   	ret    
801029f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a00 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a00:	c3                   	ret    
80102a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0f:	90                   	nop

80102a10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a11:	b0 0f                	mov    $0xf,%al
80102a13:	89 e5                	mov    %esp,%ebp
80102a15:	ba 70 00 00 00       	mov    $0x70,%edx
80102a1a:	53                   	push   %ebx
80102a1b:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
80102a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102a22:	ee                   	out    %al,(%dx)
80102a23:	b0 0a                	mov    $0xa,%al
80102a25:	ba 71 00 00 00       	mov    $0x71,%edx
80102a2a:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a2b:	c1 e1 18             	shl    $0x18,%ecx
  wrv[0] = 0;
80102a2e:	31 c0                	xor    %eax,%eax
80102a30:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a36:	89 d8                	mov    %ebx,%eax
80102a38:	c1 e8 04             	shr    $0x4,%eax
80102a3b:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a41:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
80102a44:	a1 7c 26 11 80       	mov    0x8011267c,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a49:	81 cb 00 06 00 00    	or     $0x600,%ebx
  lapic[index] = value;
80102a4f:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a58:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102a5d:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a63:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a66:	ba 00 85 00 00       	mov    $0x8500,%edx
80102a6b:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a74:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7d:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a86:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a8c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a8f:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
    microdelay(200);
  }
}
80102a95:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102a96:	8b 40 20             	mov    0x20(%eax),%eax
}
80102a99:	5d                   	pop    %ebp
80102a9a:	c3                   	ret    
80102a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102aa0:	55                   	push   %ebp
80102aa1:	b0 0b                	mov    $0xb,%al
80102aa3:	89 e5                	mov    %esp,%ebp
80102aa5:	ba 70 00 00 00       	mov    $0x70,%edx
80102aaa:	57                   	push   %edi
80102aab:	56                   	push   %esi
80102aac:	53                   	push   %ebx
80102aad:	83 ec 5c             	sub    $0x5c,%esp
80102ab0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab1:	ba 71 00 00 00       	mov    $0x71,%edx
80102ab6:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102ab7:	24 04                	and    $0x4,%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab9:	be 70 00 00 00       	mov    $0x70,%esi
80102abe:	88 45 b2             	mov    %al,-0x4e(%ebp)
80102ac1:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102ac4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102acf:	90                   	nop
80102ad0:	31 c0                	xor    %eax,%eax
80102ad2:	89 f2                	mov    %esi,%edx
80102ad4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad5:	bb 71 00 00 00       	mov    $0x71,%ebx
80102ada:	89 da                	mov    %ebx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 f2                	mov    %esi,%edx
80102ae2:	b0 02                	mov    $0x2,%al
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 da                	mov    %ebx,%edx
80102ae7:	ec                   	in     (%dx),%al
80102ae8:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aeb:	89 f2                	mov    %esi,%edx
80102aed:	b0 04                	mov    $0x4,%al
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 da                	mov    %ebx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 f2                	mov    %esi,%edx
80102af8:	b0 07                	mov    $0x7,%al
80102afa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afb:	89 da                	mov    %ebx,%edx
80102afd:	ec                   	in     (%dx),%al
80102afe:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b01:	89 f2                	mov    %esi,%edx
80102b03:	b0 08                	mov    $0x8,%al
80102b05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b06:	89 da                	mov    %ebx,%edx
80102b08:	ec                   	in     (%dx),%al
80102b09:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0c:	89 f2                	mov    %esi,%edx
80102b0e:	b0 09                	mov    $0x9,%al
80102b10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b11:	89 da                	mov    %ebx,%edx
80102b13:	ec                   	in     (%dx),%al
80102b14:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b17:	89 f2                	mov    %esi,%edx
80102b19:	b0 0a                	mov    $0xa,%al
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 da                	mov    %ebx,%edx
80102b1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b1f:	84 c0                	test   %al,%al
80102b21:	78 ad                	js     80102ad0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102b23:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80102b26:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2a:	89 f2                	mov    %esi,%edx
80102b2c:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b2f:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b33:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b36:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b3a:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b3d:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b41:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b44:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
80102b48:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102b4b:	31 c0                	xor    %eax,%eax
80102b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	89 da                	mov    %ebx,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	89 f2                	mov    %esi,%edx
80102b56:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b59:	b0 02                	mov    $0x2,%al
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 f2                	mov    %esi,%edx
80102b64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b67:	b0 04                	mov    $0x4,%al
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	89 da                	mov    %ebx,%edx
80102b6c:	ec                   	in     (%dx),%al
80102b6d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b70:	89 f2                	mov    %esi,%edx
80102b72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b75:	b0 07                	mov    $0x7,%al
80102b77:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b78:	89 da                	mov    %ebx,%edx
80102b7a:	ec                   	in     (%dx),%al
80102b7b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7e:	89 f2                	mov    %esi,%edx
80102b80:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b83:	b0 08                	mov    $0x8,%al
80102b85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b86:	89 da                	mov    %ebx,%edx
80102b88:	ec                   	in     (%dx),%al
80102b89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8c:	89 f2                	mov    %esi,%edx
80102b8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b91:	b0 09                	mov    $0x9,%al
80102b93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	89 da                	mov    %ebx,%edx
80102b96:	ec                   	in     (%dx),%al
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  return inb(CMOS_RETURN);
80102b9b:	0f b6 c0             	movzbl %al,%eax
80102b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ba1:	b8 18 00 00 00       	mov    $0x18,%eax
80102ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
80102baa:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bad:	89 04 24             	mov    %eax,(%esp)
80102bb0:	e8 5b 1c 00 00       	call   80104810 <memcmp>
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	0f 85 13 ff ff ff    	jne    80102ad0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102bbd:	80 7d b2 00          	cmpb   $0x0,-0x4e(%ebp)
80102bc1:	75 78                	jne    80102c3b <cmostime+0x19b>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc6:	89 c2                	mov    %eax,%edx
80102bc8:	83 e0 0f             	and    $0xf,%eax
80102bcb:	c1 ea 04             	shr    $0x4,%edx
80102bce:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd1:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bd7:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bda:	89 c2                	mov    %eax,%edx
80102bdc:	83 e0 0f             	and    $0xf,%eax
80102bdf:	c1 ea 04             	shr    $0x4,%edx
80102be2:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102be5:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102beb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bee:	89 c2                	mov    %eax,%edx
80102bf0:	83 e0 0f             	and    $0xf,%eax
80102bf3:	c1 ea 04             	shr    $0x4,%edx
80102bf6:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf9:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bfc:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c02:	89 c2                	mov    %eax,%edx
80102c04:	83 e0 0f             	and    $0xf,%eax
80102c07:	c1 ea 04             	shr    $0x4,%edx
80102c0a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c13:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c16:	89 c2                	mov    %eax,%edx
80102c18:	83 e0 0f             	and    $0xf,%eax
80102c1b:	c1 ea 04             	shr    $0x4,%edx
80102c1e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c21:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c24:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c27:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c2a:	89 c2                	mov    %eax,%edx
80102c2c:	83 e0 0f             	and    $0xf,%eax
80102c2f:	c1 ea 04             	shr    $0x4,%edx
80102c32:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c35:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c38:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102c3e:	31 c0                	xor    %eax,%eax
80102c40:	8b 54 05 b8          	mov    -0x48(%ebp,%eax,1),%edx
80102c44:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80102c47:	83 c0 04             	add    $0x4,%eax
80102c4a:	83 f8 18             	cmp    $0x18,%eax
80102c4d:	72 f1                	jb     80102c40 <cmostime+0x1a0>
  r->year += 2000;
80102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c52:	81 40 14 d0 07 00 00 	addl   $0x7d0,0x14(%eax)
}
80102c59:	83 c4 5c             	add    $0x5c,%esp
80102c5c:	5b                   	pop    %ebx
80102c5d:	5e                   	pop    %esi
80102c5e:	5f                   	pop    %edi
80102c5f:	5d                   	pop    %ebp
80102c60:	c3                   	ret    
80102c61:	66 90                	xchg   %ax,%ax
80102c63:	66 90                	xchg   %ax,%ax
80102c65:	66 90                	xchg   %ax,%ax
80102c67:	66 90                	xchg   %ax,%ax
80102c69:	66 90                	xchg   %ax,%ax
80102c6b:	66 90                	xchg   %ax,%ax
80102c6d:	66 90                	xchg   %ax,%ax
80102c6f:	90                   	nop

80102c70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c70:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c76:	85 d2                	test   %edx,%edx
80102c78:	0f 8e 92 00 00 00    	jle    80102d10 <install_trans+0xa0>
{
80102c7e:	55                   	push   %ebp
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c82:	31 ff                	xor    %edi,%edi
{
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 1c             	sub    $0x1c,%esp
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c90:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c95:	01 f8                	add    %edi,%eax
80102c97:	40                   	inc    %eax
80102c98:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c9c:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102ca1:	89 04 24             	mov    %eax,(%esp)
80102ca4:	e8 27 d4 ff ff       	call   801000d0 <bread>
80102ca9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cab:	8b 04 bd cc 26 11 80 	mov    -0x7feed934(,%edi,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	47                   	inc    %edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cb7:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102cbc:	89 04 24             	mov    %eax,(%esp)
80102cbf:	e8 0c d4 ff ff       	call   801000d0 <bread>
80102cc4:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc6:	b8 00 02 00 00       	mov    $0x200,%eax
80102ccb:	89 44 24 08          	mov    %eax,0x8(%esp)
80102ccf:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cd6:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cd9:	89 04 24             	mov    %eax,(%esp)
80102cdc:	e8 7f 1b 00 00       	call   80104860 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ce1:	89 1c 24             	mov    %ebx,(%esp)
80102ce4:	e8 c7 d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ce9:	89 34 24             	mov    %esi,(%esp)
80102cec:	e8 ff d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cf1:	89 1c 24             	mov    %ebx,(%esp)
80102cf4:	e8 f7 d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf9:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102cff:	7f 8f                	jg     80102c90 <install_trans+0x20>
  }
}
80102d01:	83 c4 1c             	add    $0x1c,%esp
80102d04:	5b                   	pop    %ebx
80102d05:	5e                   	pop    %esi
80102d06:	5f                   	pop    %edi
80102d07:	5d                   	pop    %ebp
80102d08:	c3                   	ret    
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d10:	c3                   	ret    
80102d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop

80102d20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 14             	sub    $0x14,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d27:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d30:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102d35:	89 04 24             	mov    %eax,(%esp)
80102d38:	e8 93 d3 ff ff       	call   801000d0 <bread>
80102d3d:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d3f:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102d44:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d47:	85 c0                	test   %eax,%eax
80102d49:	7e 15                	jle    80102d60 <write_head+0x40>
80102d4b:	31 d2                	xor    %edx,%edx
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi
    hb->block[i] = log.lh.block[i];
80102d50:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102d57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	42                   	inc    %edx
80102d5c:	39 d0                	cmp    %edx,%eax
80102d5e:	75 f0                	jne    80102d50 <write_head+0x30>
  }
  bwrite(buf);
80102d60:	89 1c 24             	mov    %ebx,(%esp)
80102d63:	e8 48 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d68:	89 1c 24             	mov    %ebx,(%esp)
80102d6b:	e8 80 d4 ff ff       	call   801001f0 <brelse>
}
80102d70:	83 c4 14             	add    $0x14,%esp
80102d73:	5b                   	pop    %ebx
80102d74:	5d                   	pop    %ebp
80102d75:	c3                   	ret    
80102d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi

80102d80 <initlog>:
{
80102d80:	55                   	push   %ebp
  initlock(&log.lock, "log");
80102d81:	ba c0 76 10 80       	mov    $0x801076c0,%edx
{
80102d86:	89 e5                	mov    %esp,%ebp
80102d88:	53                   	push   %ebx
80102d89:	83 ec 34             	sub    $0x34,%esp
  initlock(&log.lock, "log");
80102d8c:	89 54 24 04          	mov    %edx,0x4(%esp)
{
80102d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d9a:	e8 91 17 00 00       	call   80104530 <initlock>
  readsb(dev, &sb);
80102d9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102da2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da6:	89 1c 24             	mov    %ebx,(%esp)
80102da9:	e8 c2 e7 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102db1:	89 1c 24             	mov    %ebx,(%esp)
  log.size = sb.nlog;
80102db4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.dev = dev;
80102db7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.start = sb.logstart;
80102dc1:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102dc6:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102dcc:	e8 ff d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102dd1:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102dd4:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102dda:	85 c9                	test   %ecx,%ecx
80102ddc:	7e 12                	jle    80102df0 <initlog+0x70>
80102dde:	31 d2                	xor    %edx,%edx
    log.lh.block[i] = lh->block[i];
80102de0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102de4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102deb:	42                   	inc    %edx
80102dec:	39 d1                	cmp    %edx,%ecx
80102dee:	75 f0                	jne    80102de0 <initlog+0x60>
  brelse(buf);
80102df0:	89 04 24             	mov    %eax,(%esp)
80102df3:	e8 f8 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102df8:	e8 73 fe ff ff       	call   80102c70 <install_trans>
  log.lh.n = 0;
80102dfd:	31 c0                	xor    %eax,%eax
80102dff:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  write_head(); // clear the log
80102e04:	e8 17 ff ff ff       	call   80102d20 <write_head>
}
80102e09:	83 c4 34             	add    $0x34,%esp
80102e0c:	5b                   	pop    %ebx
80102e0d:	5d                   	pop    %ebp
80102e0e:	c3                   	ret    
80102e0f:	90                   	nop

80102e10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102e16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e1d:	e8 7e 18 00 00       	call   801046a0 <acquire>
80102e22:	eb 21                	jmp    80102e45 <begin_op+0x35>
80102e24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e30:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e37:	b8 80 26 11 80       	mov    $0x80112680,%eax
80102e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e40:	e8 4b 11 00 00       	call   80103f90 <sleep>
    if(log.committing){
80102e45:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
80102e4b:	85 d2                	test   %edx,%edx
80102e4d:	75 e1                	jne    80102e30 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e4f:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e54:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80102e58:	8d 48 01             	lea    0x1(%eax),%ecx
80102e5b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102e60:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e63:	83 f8 1e             	cmp    $0x1e,%eax
80102e66:	7f c8                	jg     80102e30 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e68:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102e6f:	89 0d bc 26 11 80    	mov    %ecx,0x801126bc
      release(&log.lock);
80102e75:	e8 d6 18 00 00       	call   80104750 <release>
      break;
    }
  }
}
80102e7a:	c9                   	leave  
80102e7b:	c3                   	ret    
80102e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	57                   	push   %edi
80102e84:	56                   	push   %esi
80102e85:	53                   	push   %ebx
80102e86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e89:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e90:	e8 0b 18 00 00       	call   801046a0 <acquire>
  log.outstanding -= 1;
80102e95:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e9a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e9d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
  log.outstanding -= 1;
80102ea2:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102ea8:	85 c0                	test   %eax,%eax
80102eaa:	0f 85 ed 00 00 00    	jne    80102f9d <end_op+0x11d>
    panic("log.committing");
  if(log.outstanding == 0){
80102eb0:	85 db                	test   %ebx,%ebx
80102eb2:	75 34                	jne    80102ee8 <end_op+0x68>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102eb4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 1;
80102ebb:	be 01 00 00 00       	mov    $0x1,%esi
80102ec0:	89 35 c0 26 11 80    	mov    %esi,0x801126c0
  release(&log.lock);
80102ec6:	e8 85 18 00 00       	call   80104750 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ecb:	8b 3d c8 26 11 80    	mov    0x801126c8,%edi
80102ed1:	85 ff                	test   %edi,%edi
80102ed3:	7f 3b                	jg     80102f10 <end_op+0x90>
    acquire(&log.lock);
80102ed5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102edc:	e8 bf 17 00 00       	call   801046a0 <acquire>
    log.committing = 0;
80102ee1:	31 c0                	xor    %eax,%eax
80102ee3:	a3 c0 26 11 80       	mov    %eax,0x801126c0
    wakeup(&log);
80102ee8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102eef:	e8 6c 12 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102ef4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102efb:	e8 50 18 00 00       	call   80104750 <release>
}
80102f00:	83 c4 1c             	add    $0x1c,%esp
80102f03:	5b                   	pop    %ebx
80102f04:	5e                   	pop    %esi
80102f05:	5f                   	pop    %edi
80102f06:	5d                   	pop    %ebp
80102f07:	c3                   	ret    
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f10:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102f15:	01 d8                	add    %ebx,%eax
80102f17:	40                   	inc    %eax
80102f18:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f1c:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102f21:	89 04 24             	mov    %eax,(%esp)
80102f24:	e8 a7 d1 ff ff       	call   801000d0 <bread>
80102f29:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f2b:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102f32:	43                   	inc    %ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f33:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f37:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102f3c:	89 04 24             	mov    %eax,(%esp)
80102f3f:	e8 8c d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f44:	b9 00 02 00 00       	mov    $0x200,%ecx
80102f49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f4d:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f4f:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f52:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f56:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f59:	89 04 24             	mov    %eax,(%esp)
80102f5c:	e8 ff 18 00 00       	call   80104860 <memmove>
    bwrite(to);  // write the log
80102f61:	89 34 24             	mov    %esi,(%esp)
80102f64:	e8 47 d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f69:	89 3c 24             	mov    %edi,(%esp)
80102f6c:	e8 7f d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f71:	89 34 24             	mov    %esi,(%esp)
80102f74:	e8 77 d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f79:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102f7f:	7c 8f                	jl     80102f10 <end_op+0x90>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f81:	e8 9a fd ff ff       	call   80102d20 <write_head>
    install_trans(); // Now install writes to home locations
80102f86:	e8 e5 fc ff ff       	call   80102c70 <install_trans>
    log.lh.n = 0;
80102f8b:	31 d2                	xor    %edx,%edx
80102f8d:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
    write_head();    // Erase the transaction from the log
80102f93:	e8 88 fd ff ff       	call   80102d20 <write_head>
80102f98:	e9 38 ff ff ff       	jmp    80102ed5 <end_op+0x55>
    panic("log.committing");
80102f9d:	c7 04 24 c4 76 10 80 	movl   $0x801076c4,(%esp)
80102fa4:	e8 b7 d3 ff ff       	call   80100360 <panic>
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	0f 8f 83 00 00 00    	jg     8010304c <log_write+0x9c>
80102fc9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102fce:	48                   	dec    %eax
80102fcf:	39 c2                	cmp    %eax,%edx
80102fd1:	7d 79                	jge    8010304c <log_write+0x9c>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	7e 7c                	jle    80103058 <log_write+0xa8>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fdc:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102fe3:	e8 b8 16 00 00       	call   801046a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fe8:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102fee:	85 d2                	test   %edx,%edx
80102ff0:	7e 4e                	jle    80103040 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff2:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ff5:	31 c0                	xor    %eax,%eax
80102ff7:	eb 0c                	jmp    80103005 <log_write+0x55>
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103000:	40                   	inc    %eax
80103001:	39 c2                	cmp    %eax,%edx
80103003:	74 2b                	je     80103030 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103005:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
8010300c:	75 f2                	jne    80103000 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
8010300e:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103015:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103018:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
8010301f:	83 c4 14             	add    $0x14,%esp
80103022:	5b                   	pop    %ebx
80103023:	5d                   	pop    %ebp
  release(&log.lock);
80103024:	e9 27 17 00 00       	jmp    80104750 <release>
80103029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80103037:	42                   	inc    %edx
80103038:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
8010303e:	eb d5                	jmp    80103015 <log_write+0x65>
  log.lh.block[i] = b->blockno;
80103040:	8b 43 08             	mov    0x8(%ebx),%eax
80103043:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80103048:	75 cb                	jne    80103015 <log_write+0x65>
8010304a:	eb eb                	jmp    80103037 <log_write+0x87>
    panic("too big a transaction");
8010304c:	c7 04 24 d3 76 10 80 	movl   $0x801076d3,(%esp)
80103053:	e8 08 d3 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80103058:	c7 04 24 e9 76 10 80 	movl   $0x801076e9,(%esp)
8010305f:	e8 fc d2 ff ff       	call   80100360 <panic>
80103064:	66 90                	xchg   %ax,%ax
80103066:	66 90                	xchg   %ax,%ax
80103068:	66 90                	xchg   %ax,%ax
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103077:	e8 64 09 00 00       	call   801039e0 <cpuid>
8010307c:	89 c3                	mov    %eax,%ebx
8010307e:	e8 5d 09 00 00       	call   801039e0 <cpuid>
80103083:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103087:	c7 04 24 04 77 10 80 	movl   $0x80107704,(%esp)
8010308e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103092:	e8 e9 d5 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103097:	e8 24 29 00 00       	call   801059c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010309c:	e8 cf 08 00 00       	call   80103970 <mycpu>
801030a1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030a3:	b8 01 00 00 00       	mov    $0x1,%eax
801030a8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030af:	e8 1c 0c 00 00       	call   80103cd0 <scheduler>
801030b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop

801030c0 <mpenter>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030c6:	e8 25 3a 00 00       	call   80106af0 <switchkvm>
  seginit();
801030cb:	e8 90 39 00 00       	call   80106a60 <seginit>
  lapicinit();
801030d0:	e8 eb f7 ff ff       	call   801028c0 <lapicinit>
  mpmain();
801030d5:	e8 96 ff ff ff       	call   80103070 <mpmain>
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <main>:
{
801030e0:	55                   	push   %ebp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030e1:	b8 00 00 40 80       	mov    $0x80400000,%eax
{
801030e6:	89 e5                	mov    %esp,%ebp
801030e8:	53                   	push   %ebx
801030e9:	83 e4 f0             	and    $0xfffffff0,%esp
801030ec:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f3:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
801030fa:	e8 71 f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
801030ff:	e8 dc 3e 00 00       	call   80106fe0 <kvmalloc>
  mpinit();        // detect other processors
80103104:	e8 97 01 00 00       	call   801032a0 <mpinit>
  lapicinit();     // interrupt controller
80103109:	e8 b2 f7 ff ff       	call   801028c0 <lapicinit>
  seginit();       // segment descriptors
8010310e:	66 90                	xchg   %ax,%ax
80103110:	e8 4b 39 00 00       	call   80106a60 <seginit>
  picinit();       // disable pic
80103115:	e8 56 03 00 00       	call   80103470 <picinit>
  ioapicinit();    // another interrupt controller
8010311a:	e8 71 f3 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
8010311f:	90                   	nop
80103120:	e8 fb d8 ff ff       	call   80100a20 <consoleinit>
  uartinit();      // serial port
80103125:	e8 e6 2b 00 00       	call   80105d10 <uartinit>
  pinit();         // process table
8010312a:	e8 21 08 00 00       	call   80103950 <pinit>
  tvinit();        // trap vectors
8010312f:	90                   	nop
80103130:	e8 0b 28 00 00       	call   80105940 <tvinit>
  binit();         // buffer cache
80103135:	e8 06 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010313a:	e8 c1 dc ff ff       	call   80100e00 <fileinit>
  ideinit();       // disk 
8010313f:	90                   	nop
80103140:	e8 3b f1 ff ff       	call   80102280 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103145:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010314a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010314e:	b8 8c a4 10 80       	mov    $0x8010a48c,%eax
80103153:	89 44 24 04          	mov    %eax,0x4(%esp)
80103157:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
8010315e:	e8 fd 16 00 00       	call   80104860 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103163:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80103168:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010316b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010316e:	c1 e0 04             	shl    $0x4,%eax
80103171:	05 80 27 11 80       	add    $0x80112780,%eax
80103176:	3d 80 27 11 80       	cmp    $0x80112780,%eax
8010317b:	0f 86 7f 00 00 00    	jbe    80103200 <main+0x120>
80103181:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103186:	eb 25                	jmp    801031ad <main+0xcd>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80103195:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010319b:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010319e:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031a1:	c1 e0 04             	shl    $0x4,%eax
801031a4:	05 80 27 11 80       	add    $0x80112780,%eax
801031a9:	39 c3                	cmp    %eax,%ebx
801031ab:	73 53                	jae    80103200 <main+0x120>
    if(c == mycpu())  // We've started already.
801031ad:	e8 be 07 00 00       	call   80103970 <mycpu>
801031b2:	39 c3                	cmp    %eax,%ebx
801031b4:	74 da                	je     80103190 <main+0xb0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031b6:	e8 85 f5 ff ff       	call   80102740 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
801031bb:	ba c0 30 10 80       	mov    $0x801030c0,%edx
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031c0:	b9 00 90 10 00       	mov    $0x109000,%ecx
    *(void(**)(void))(code-8) = mpenter;
801031c5:	89 15 f8 6f 00 80    	mov    %edx,0x80006ff8
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031cb:	89 0d f4 6f 00 80    	mov    %ecx,0x80006ff4
    *(void**)(code-4) = stack + KSTACKSIZE;
801031d1:	05 00 10 00 00       	add    $0x1000,%eax
801031d6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801031db:	b8 00 70 00 00       	mov    $0x7000,%eax
801031e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801031e4:	0f b6 03             	movzbl (%ebx),%eax
801031e7:	89 04 24             	mov    %eax,(%esp)
801031ea:	e8 21 f8 ff ff       	call   80102a10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031ef:	90                   	nop
801031f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031f6:	85 c0                	test   %eax,%eax
801031f8:	74 f6                	je     801031f0 <main+0x110>
801031fa:	eb 94                	jmp    80103190 <main+0xb0>
801031fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103200:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103207:	b8 00 00 00 8e       	mov    $0x8e000000,%eax
8010320c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103210:	e8 cb f4 ff ff       	call   801026e0 <kinit2>
  userinit();      // first user process
80103215:	e8 16 08 00 00       	call   80103a30 <userinit>
  mpmain();        // finish this processor's setup
8010321a:	e8 51 fe ff ff       	call   80103070 <mpmain>
8010321f:	90                   	nop

80103220 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80103226:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010322c:	83 ec 1c             	sub    $0x1c,%esp
  e = addr+len;
8010322f:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80103236:	39 de                	cmp    %ebx,%esi
80103238:	72 0c                	jb     80103246 <mpsearch1+0x26>
8010323a:	eb 54                	jmp    80103290 <mpsearch1+0x70>
8010323c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103240:	39 cb                	cmp    %ecx,%ebx
80103242:	89 ce                	mov    %ecx,%esi
80103244:	76 4a                	jbe    80103290 <mpsearch1+0x70>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103246:	89 34 24             	mov    %esi,(%esp)
80103249:	b8 04 00 00 00       	mov    $0x4,%eax
8010324e:	ba 18 77 10 80       	mov    $0x80107718,%edx
80103253:	89 44 24 08          	mov    %eax,0x8(%esp)
80103257:	89 54 24 04          	mov    %edx,0x4(%esp)
8010325b:	e8 b0 15 00 00       	call   80104810 <memcmp>
80103260:	8d 4e 10             	lea    0x10(%esi),%ecx
80103263:	85 c0                	test   %eax,%eax
80103265:	75 d9                	jne    80103240 <mpsearch1+0x20>
80103267:	89 f2                	mov    %esi,%edx
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103270:	0f b6 3a             	movzbl (%edx),%edi
80103273:	42                   	inc    %edx
80103274:	01 f8                	add    %edi,%eax
  for(i=0; i<len; i++)
80103276:	39 ca                	cmp    %ecx,%edx
80103278:	75 f6                	jne    80103270 <mpsearch1+0x50>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010327a:	84 c0                	test   %al,%al
8010327c:	75 c2                	jne    80103240 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
8010327e:	83 c4 1c             	add    $0x1c,%esp
80103281:	89 f0                	mov    %esi,%eax
80103283:	5b                   	pop    %ebx
80103284:	5e                   	pop    %esi
80103285:	5f                   	pop    %edi
80103286:	5d                   	pop    %ebp
80103287:	c3                   	ret    
80103288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop
80103290:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80103293:	31 f6                	xor    %esi,%esi
}
80103295:	5b                   	pop    %ebx
80103296:	89 f0                	mov    %esi,%eax
80103298:	5e                   	pop    %esi
80103299:	5f                   	pop    %edi
8010329a:	5d                   	pop    %ebp
8010329b:	c3                   	ret    
8010329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 2c             	sub    $0x2c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032b7:	c1 e0 08             	shl    $0x8,%eax
801032ba:	09 d0                	or     %edx,%eax
801032bc:	c1 e0 04             	shl    $0x4,%eax
801032bf:	75 1b                	jne    801032dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032cf:	c1 e0 08             	shl    $0x8,%eax
801032d2:	09 d0                	or     %edx,%eax
801032d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032dc:	ba 00 04 00 00       	mov    $0x400,%edx
801032e1:	e8 3a ff ff ff       	call   80103220 <mpsearch1>
801032e6:	85 c0                	test   %eax,%eax
801032e8:	89 c6                	mov    %eax,%esi
801032ea:	0f 84 40 01 00 00    	je     80103430 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f0:	8b 5e 04             	mov    0x4(%esi),%ebx
801032f3:	85 db                	test   %ebx,%ebx
801032f5:	0f 84 55 01 00 00    	je     80103450 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032fb:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103301:	ba 04 00 00 00       	mov    $0x4,%edx
80103306:	89 54 24 08          	mov    %edx,0x8(%esp)
8010330a:	b9 1d 77 10 80       	mov    $0x8010771d,%ecx
8010330f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80103313:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103319:	e8 f2 14 00 00       	call   80104810 <memcmp>
8010331e:	85 c0                	test   %eax,%eax
80103320:	0f 85 2a 01 00 00    	jne    80103450 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103326:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010332d:	3c 01                	cmp    $0x1,%al
8010332f:	74 08                	je     80103339 <mpinit+0x99>
80103331:	3c 04                	cmp    $0x4,%al
80103333:	0f 85 17 01 00 00    	jne    80103450 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103339:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103340:	85 ff                	test   %edi,%edi
80103342:	74 22                	je     80103366 <mpinit+0xc6>
80103344:	89 d8                	mov    %ebx,%eax
80103346:	01 df                	add    %ebx,%edi
  sum = 0;
80103348:	31 d2                	xor    %edx,%edx
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103350:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103357:	40                   	inc    %eax
80103358:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010335a:	39 f8                	cmp    %edi,%eax
8010335c:	75 f2                	jne    80103350 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
8010335e:	84 d2                	test   %dl,%dl
80103360:	0f 85 ea 00 00 00    	jne    80103450 <mpinit+0x1b0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103366:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010336c:	8d 93 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%edx
  lapic = (uint*)conf->lapicaddr;
80103372:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010337a:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  ismp = 1;
80103381:	bb 01 00 00 00       	mov    $0x1,%ebx
80103386:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103389:	01 c1                	add    %eax,%ecx
8010338b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010338f:	90                   	nop
80103390:	39 d1                	cmp    %edx,%ecx
80103392:	76 15                	jbe    801033a9 <mpinit+0x109>
    switch(*p){
80103394:	0f b6 02             	movzbl (%edx),%eax
80103397:	3c 02                	cmp    $0x2,%al
80103399:	74 55                	je     801033f0 <mpinit+0x150>
8010339b:	77 43                	ja     801033e0 <mpinit+0x140>
8010339d:	84 c0                	test   %al,%al
8010339f:	90                   	nop
801033a0:	74 5e                	je     80103400 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033a2:	83 c2 08             	add    $0x8,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033a5:	39 d1                	cmp    %edx,%ecx
801033a7:	77 eb                	ja     80103394 <mpinit+0xf4>
801033a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033ac:	85 db                	test   %ebx,%ebx
801033ae:	0f 84 a8 00 00 00    	je     8010345c <mpinit+0x1bc>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033b4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801033b8:	74 11                	je     801033cb <mpinit+0x12b>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ba:	b0 70                	mov    $0x70,%al
801033bc:	ba 22 00 00 00       	mov    $0x22,%edx
801033c1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033c2:	ba 23 00 00 00       	mov    $0x23,%edx
801033c7:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033c8:	0c 01                	or     $0x1,%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ca:	ee                   	out    %al,(%dx)
  }
}
801033cb:	83 c4 2c             	add    $0x2c,%esp
801033ce:	5b                   	pop    %ebx
801033cf:	5e                   	pop    %esi
801033d0:	5f                   	pop    %edi
801033d1:	5d                   	pop    %ebp
801033d2:	c3                   	ret    
801033d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(*p){
801033e0:	2c 03                	sub    $0x3,%al
801033e2:	3c 01                	cmp    $0x1,%al
801033e4:	76 bc                	jbe    801033a2 <mpinit+0x102>
801033e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801033ed:	eb a1                	jmp    80103390 <mpinit+0xf0>
801033ef:	90                   	nop
      ioapicid = ioapic->apicno;
801033f0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
801033f4:	83 c2 08             	add    $0x8,%edx
      ioapicid = ioapic->apicno;
801033f7:	a2 60 27 11 80       	mov    %al,0x80112760
      continue;
801033fc:	eb 92                	jmp    80103390 <mpinit+0xf0>
801033fe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103400:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80103405:	83 f8 07             	cmp    $0x7,%eax
80103408:	7f 19                	jg     80103423 <mpinit+0x183>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010340a:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
8010340e:	8d 3c 80             	lea    (%eax,%eax,4),%edi
80103411:	8d 3c 78             	lea    (%eax,%edi,2),%edi
        ncpu++;
80103414:	40                   	inc    %eax
80103415:	a3 00 2d 11 80       	mov    %eax,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010341a:	c1 e7 04             	shl    $0x4,%edi
8010341d:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103423:	83 c2 14             	add    $0x14,%edx
      continue;
80103426:	e9 65 ff ff ff       	jmp    80103390 <mpinit+0xf0>
8010342b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103430:	ba 00 00 01 00       	mov    $0x10000,%edx
80103435:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010343a:	e8 e1 fd ff ff       	call   80103220 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010343f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103441:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103443:	0f 85 a7 fe ff ff    	jne    801032f0 <mpinit+0x50>
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103450:	c7 04 24 22 77 10 80 	movl   $0x80107722,(%esp)
80103457:	e8 04 cf ff ff       	call   80100360 <panic>
    panic("Didn't find a suitable machine");
8010345c:	c7 04 24 3c 77 10 80 	movl   $0x8010773c,(%esp)
80103463:	e8 f8 ce ff ff       	call   80100360 <panic>
80103468:	66 90                	xchg   %ax,%ax
8010346a:	66 90                	xchg   %ax,%ax
8010346c:	66 90                	xchg   %ax,%ax
8010346e:	66 90                	xchg   %ax,%ax

80103470 <picinit>:
80103470:	b0 ff                	mov    $0xff,%al
80103472:	ba 21 00 00 00       	mov    $0x21,%edx
80103477:	ee                   	out    %al,(%dx)
80103478:	ba a1 00 00 00       	mov    $0xa1,%edx
8010347d:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
8010347e:	c3                   	ret    
8010347f:	90                   	nop

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	83 ec 28             	sub    $0x28,%esp
80103486:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010348f:	8b 75 0c             	mov    0xc(%ebp),%esi
80103492:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010349b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034a1:	e8 7a d9 ff ff       	call   80100e20 <filealloc>
801034a6:	89 03                	mov    %eax,(%ebx)
801034a8:	85 c0                	test   %eax,%eax
801034aa:	0f 84 ae 00 00 00    	je     8010355e <pipealloc+0xde>
801034b0:	e8 6b d9 ff ff       	call   80100e20 <filealloc>
801034b5:	89 06                	mov    %eax,(%esi)
801034b7:	85 c0                	test   %eax,%eax
801034b9:	0f 84 91 00 00 00    	je     80103550 <pipealloc+0xd0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034bf:	e8 7c f2 ff ff       	call   80102740 <kalloc>
801034c4:	85 c0                	test   %eax,%eax
801034c6:	89 c7                	mov    %eax,%edi
801034c8:	0f 84 b2 00 00 00    	je     80103580 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801034ce:	b8 01 00 00 00       	mov    $0x1,%eax
  p->writeopen = 1;
801034d3:	ba 01 00 00 00       	mov    $0x1,%edx
  p->readopen = 1;
801034d8:	89 87 3c 02 00 00    	mov    %eax,0x23c(%edi)
  p->nwrite = 0;
  p->nread = 0;
801034de:	31 c0                	xor    %eax,%eax
  p->nwrite = 0;
801034e0:	31 c9                	xor    %ecx,%ecx
  p->nread = 0;
801034e2:	89 87 34 02 00 00    	mov    %eax,0x234(%edi)
  initlock(&p->lock, "pipe");
801034e8:	b8 5b 77 10 80       	mov    $0x8010775b,%eax
  p->writeopen = 1;
801034ed:	89 97 40 02 00 00    	mov    %edx,0x240(%edi)
  p->nwrite = 0;
801034f3:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
  initlock(&p->lock, "pipe");
801034f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801034fd:	89 3c 24             	mov    %edi,(%esp)
80103500:	e8 2b 10 00 00       	call   80104530 <initlock>
  (*f0)->type = FD_PIPE;
80103505:	8b 03                	mov    (%ebx),%eax
80103507:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010350d:	8b 03                	mov    (%ebx),%eax
8010350f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103513:	8b 03                	mov    (%ebx),%eax
80103515:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103519:	8b 03                	mov    (%ebx),%eax
8010351b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351e:	8b 06                	mov    (%esi),%eax
80103520:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103526:	8b 06                	mov    (%esi),%eax
80103528:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010352c:	8b 06                	mov    (%esi),%eax
8010352e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103532:	8b 06                	mov    (%esi),%eax
80103534:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80103537:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103539:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010353c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010353f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80103542:	89 ec                	mov    %ebp,%esp
80103544:	5d                   	pop    %ebp
80103545:	c3                   	ret    
80103546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	74 16                	je     8010356c <pipealloc+0xec>
    fileclose(*f0);
80103556:	89 04 24             	mov    %eax,(%esp)
80103559:	e8 82 d9 ff ff       	call   80100ee0 <fileclose>
  if(*f1)
8010355e:	8b 06                	mov    (%esi),%eax
80103560:	85 c0                	test   %eax,%eax
80103562:	74 08                	je     8010356c <pipealloc+0xec>
    fileclose(*f1);
80103564:	89 04 24             	mov    %eax,(%esp)
80103567:	e8 74 d9 ff ff       	call   80100ee0 <fileclose>
}
8010356c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  return -1;
8010356f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103574:	8b 75 f8             	mov    -0x8(%ebp),%esi
80103577:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010357a:	89 ec                	mov    %ebp,%esp
8010357c:	5d                   	pop    %ebp
8010357d:	c3                   	ret    
8010357e:	66 90                	xchg   %ax,%ax
  if(*f0)
80103580:	8b 03                	mov    (%ebx),%eax
80103582:	85 c0                	test   %eax,%eax
80103584:	75 d0                	jne    80103556 <pipealloc+0xd6>
80103586:	eb d6                	jmp    8010355e <pipealloc+0xde>
80103588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358f:	90                   	nop

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	83 ec 18             	sub    $0x18,%esp
80103596:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010359c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010359f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035a2:	89 1c 24             	mov    %ebx,(%esp)
801035a5:	e8 f6 10 00 00       	call   801046a0 <acquire>
  if(writable){
801035aa:	85 f6                	test   %esi,%esi
801035ac:	74 42                	je     801035f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b4:	31 f6                	xor    %esi,%esi
801035b6:	89 b3 40 02 00 00    	mov    %esi,0x240(%ebx)
    wakeup(&p->nread);
801035bc:	89 04 24             	mov    %eax,(%esp)
801035bf:	e8 9c 0b 00 00       	call   80104160 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c4:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ca:	85 d2                	test   %edx,%edx
801035cc:	75 0a                	jne    801035d8 <pipeclose+0x48>
801035ce:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d4:	85 c0                	test   %eax,%eax
801035d6:	74 38                	je     80103610 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035db:	8b 75 fc             	mov    -0x4(%ebp),%esi
801035de:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801035e1:	89 ec                	mov    %ebp,%esp
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 67 11 00 00       	jmp    80104750 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801035f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f6:	31 c9                	xor    %ecx,%ecx
801035f8:	89 8b 3c 02 00 00    	mov    %ecx,0x23c(%ebx)
    wakeup(&p->nwrite);
801035fe:	89 04 24             	mov    %eax,(%esp)
80103601:	e8 5a 0b 00 00       	call   80104160 <wakeup>
80103606:	eb bc                	jmp    801035c4 <pipeclose+0x34>
80103608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010360f:	90                   	nop
    release(&p->lock);
80103610:	89 1c 24             	mov    %ebx,(%esp)
80103613:	e8 38 11 00 00       	call   80104750 <release>
}
80103618:	8b 75 fc             	mov    -0x4(%ebp),%esi
    kfree((char*)p);
8010361b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010361e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103621:	89 ec                	mov    %ebp,%esp
80103623:	5d                   	pop    %ebp
    kfree((char*)p);
80103624:	e9 57 ef ff ff       	jmp    80102580 <kfree>
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 2c             	sub    $0x2c,%esp
80103639:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363c:	89 3c 24             	mov    %edi,(%esp)
8010363f:	e8 5c 10 00 00       	call   801046a0 <acquire>
  for(i = 0; i < n; i++){
80103644:	8b 75 10             	mov    0x10(%ebp),%esi
80103647:	85 f6                	test   %esi,%esi
80103649:	0f 8e c7 00 00 00    	jle    80103716 <pipewrite+0xe6>
8010364f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103652:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103658:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010365b:	8b 87 38 02 00 00    	mov    0x238(%edi),%eax
80103661:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103664:	01 d9                	add    %ebx,%ecx
80103666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103669:	8b 8f 34 02 00 00    	mov    0x234(%edi),%ecx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103675:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010367b:	39 d0                	cmp    %edx,%eax
8010367d:	74 46                	je     801036c5 <pipewrite+0x95>
8010367f:	eb 63                	jmp    801036e4 <pipewrite+0xb4>
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103690:	e8 6b 03 00 00       	call   80103a00 <myproc>
80103695:	8b 40 24             	mov    0x24(%eax),%eax
80103698:	85 c0                	test   %eax,%eax
8010369a:	75 33                	jne    801036cf <pipewrite+0x9f>
      wakeup(&p->nread);
8010369c:	89 34 24             	mov    %esi,(%esp)
8010369f:	e8 bc 0a 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
801036a8:	89 1c 24             	mov    %ebx,(%esp)
801036ab:	e8 e0 08 00 00       	call   80103f90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b0:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801036b6:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801036bc:	05 00 02 00 00       	add    $0x200,%eax
801036c1:	39 c2                	cmp    %eax,%edx
801036c3:	75 2b                	jne    801036f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036c5:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801036cb:	85 d2                	test   %edx,%edx
801036cd:	75 c1                	jne    80103690 <pipewrite+0x60>
        release(&p->lock);
801036cf:	89 3c 24             	mov    %edi,(%esp)
801036d2:	e8 79 10 00 00       	call   80104750 <release>
        return -1;
801036d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036dc:	83 c4 2c             	add    $0x2c,%esp
801036df:	5b                   	pop    %ebx
801036e0:	5e                   	pop    %esi
801036e1:	5f                   	pop    %edi
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036e4:	89 c2                	mov    %eax,%edx
801036e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801036f3:	8d 42 01             	lea    0x1(%edx),%eax
801036f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036fc:	89 87 38 02 00 00    	mov    %eax,0x238(%edi)
80103702:	0f b6 0b             	movzbl (%ebx),%ecx
80103705:	43                   	inc    %ebx
  for(i = 0; i < n; i++){
80103706:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80103709:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010370c:	88 4c 17 34          	mov    %cl,0x34(%edi,%edx,1)
  for(i = 0; i < n; i++){
80103710:	0f 85 53 ff ff ff    	jne    80103669 <pipewrite+0x39>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103716:	8d 87 34 02 00 00    	lea    0x234(%edi),%eax
8010371c:	89 04 24             	mov    %eax,(%esp)
8010371f:	e8 3c 0a 00 00       	call   80104160 <wakeup>
  release(&p->lock);
80103724:	89 3c 24             	mov    %edi,(%esp)
80103727:	e8 24 10 00 00       	call   80104750 <release>
  return n;
8010372c:	8b 45 10             	mov    0x10(%ebp),%eax
8010372f:	eb ab                	jmp    801036dc <pipewrite+0xac>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop

80103740 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	57                   	push   %edi
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 1c             	sub    $0x1c,%esp
80103749:	8b 75 08             	mov    0x8(%ebp),%esi
8010374c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010374f:	89 34 24             	mov    %esi,(%esp)
80103752:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103758:	e8 43 0f 00 00       	call   801046a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010375d:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103763:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103769:	74 2f                	je     8010379a <piperead+0x5a>
8010376b:	eb 37                	jmp    801037a4 <piperead+0x64>
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103770:	e8 8b 02 00 00       	call   80103a00 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	0f 85 80 00 00 00    	jne    80103800 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103780:	89 74 24 04          	mov    %esi,0x4(%esp)
80103784:	89 1c 24             	mov    %ebx,(%esp)
80103787:	e8 04 08 00 00       	call   80103f90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010378c:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103792:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103798:	75 0a                	jne    801037a4 <piperead+0x64>
8010379a:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037a0:	85 c0                	test   %eax,%eax
801037a2:	75 cc                	jne    80103770 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037a4:	8b 55 10             	mov    0x10(%ebp),%edx
801037a7:	31 db                	xor    %ebx,%ebx
801037a9:	85 d2                	test   %edx,%edx
801037ab:	7f 1f                	jg     801037cc <piperead+0x8c>
801037ad:	eb 2b                	jmp    801037da <piperead+0x9a>
801037af:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037b0:	8d 48 01             	lea    0x1(%eax),%ecx
801037b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c6:	43                   	inc    %ebx
801037c7:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037ca:	74 0e                	je     801037da <piperead+0x9a>
    if(p->nread == p->nwrite)
801037cc:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d2:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037d8:	75 d6                	jne    801037b0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037da:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037e0:	89 04 24             	mov    %eax,(%esp)
801037e3:	e8 78 09 00 00       	call   80104160 <wakeup>
  release(&p->lock);
801037e8:	89 34 24             	mov    %esi,(%esp)
801037eb:	e8 60 0f 00 00       	call   80104750 <release>
  return i;
}
801037f0:	83 c4 1c             	add    $0x1c,%esp
801037f3:	89 d8                	mov    %ebx,%eax
801037f5:	5b                   	pop    %ebx
801037f6:	5e                   	pop    %esi
801037f7:	5f                   	pop    %edi
801037f8:	5d                   	pop    %ebp
801037f9:	c3                   	ret    
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
80103800:	89 34 24             	mov    %esi,(%esp)
      return -1;
80103803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103808:	e8 43 0f 00 00       	call   80104750 <release>
}
8010380d:	83 c4 1c             	add    $0x1c,%esp
80103810:	89 d8                	mov    %ebx,%eax
80103812:	5b                   	pop    %ebx
80103813:	5e                   	pop    %esi
80103814:	5f                   	pop    %edi
80103815:	5d                   	pop    %ebp
80103816:	c3                   	ret    
80103817:	66 90                	xchg   %ax,%ax
80103819:	66 90                	xchg   %ax,%ax
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103829:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010382c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103833:	e8 68 0e 00 00       	call   801046a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103838:	eb 15                	jmp    8010384f <allocproc+0x2f>
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103840:	83 c3 7c             	add    $0x7c,%ebx
80103843:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103849:	0f 84 81 00 00 00    	je     801038d0 <allocproc+0xb0>
    if(p->state == UNUSED)
8010384f:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103852:	85 c9                	test   %ecx,%ecx
80103854:	75 ea                	jne    80103840 <allocproc+0x20>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103856:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010385d:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103862:	89 43 10             	mov    %eax,0x10(%ebx)
80103865:	8d 50 01             	lea    0x1(%eax),%edx

  release(&ptable.lock);
80103868:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->pid = nextpid++;
8010386f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103875:	e8 d6 0e 00 00       	call   80104750 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010387a:	e8 c1 ee ff ff       	call   80102740 <kalloc>
8010387f:	89 43 08             	mov    %eax,0x8(%ebx)
80103882:	85 c0                	test   %eax,%eax
80103884:	74 60                	je     801038e6 <allocproc+0xc6>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103886:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010388c:	b9 14 00 00 00       	mov    $0x14,%ecx
  sp -= sizeof *p->tf;
80103891:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103894:	ba 2d 59 10 80       	mov    $0x8010592d,%edx
  sp -= sizeof *p->context;
80103899:	05 9c 0f 00 00       	add    $0xf9c,%eax
  *(uint*)sp = (uint)trapret;
8010389e:	89 50 14             	mov    %edx,0x14(%eax)
  memset(p->context, 0, sizeof *p->context);
801038a1:	31 d2                	xor    %edx,%edx
  p->context = (struct context*)sp;
801038a3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801038ae:	89 04 24             	mov    %eax,(%esp)
801038b1:	e8 ea 0e 00 00       	call   801047a0 <memset>
  p->context->eip = (uint)forkret;
801038b6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801038b9:	c7 40 10 00 39 10 80 	movl   $0x80103900,0x10(%eax)

  return p;
}
801038c0:	83 c4 14             	add    $0x14,%esp
801038c3:	89 d8                	mov    %ebx,%eax
801038c5:	5b                   	pop    %ebx
801038c6:	5d                   	pop    %ebp
801038c7:	c3                   	ret    
801038c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cf:	90                   	nop
  release(&ptable.lock);
801038d0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  return 0;
801038d7:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038d9:	e8 72 0e 00 00       	call   80104750 <release>
}
801038de:	83 c4 14             	add    $0x14,%esp
801038e1:	89 d8                	mov    %ebx,%eax
801038e3:	5b                   	pop    %ebx
801038e4:	5d                   	pop    %ebp
801038e5:	c3                   	ret    
    p->state = UNUSED;
801038e6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038ed:	31 db                	xor    %ebx,%ebx
}
801038ef:	83 c4 14             	add    $0x14,%esp
801038f2:	89 d8                	mov    %ebx,%eax
801038f4:	5b                   	pop    %ebx
801038f5:	5d                   	pop    %ebp
801038f6:	c3                   	ret    
801038f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fe:	66 90                	xchg   %ax,%ax

80103900 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103906:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390d:	e8 3e 0e 00 00       	call   80104750 <release>

  if (first) {
80103912:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
80103918:	85 d2                	test   %edx,%edx
8010391a:	75 04                	jne    80103920 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    
8010391e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103920:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103927:	31 c0                	xor    %eax,%eax
80103929:	a3 00 a0 10 80       	mov    %eax,0x8010a000
    iinit(ROOTDEV);
8010392e:	e8 8d dc ff ff       	call   801015c0 <iinit>
    initlog(ROOTDEV);
80103933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010393a:	e8 41 f4 ff ff       	call   80102d80 <initlog>
}
8010393f:	c9                   	leave  
80103940:	c3                   	ret    
80103941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394f:	90                   	nop

80103950 <pinit>:
{
80103950:	55                   	push   %ebp
  initlock(&ptable.lock, "ptable");
80103951:	b8 60 77 10 80       	mov    $0x80107760,%eax
{
80103956:	89 e5                	mov    %esp,%ebp
80103958:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010395b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010395f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103966:	e8 c5 0b 00 00       	call   80104530 <initlock>
}
8010396b:	c9                   	leave  
8010396c:	c3                   	ret    
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <mycpu>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
80103975:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103978:	9c                   	pushf  
80103979:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010397a:	f6 c4 02             	test   $0x2,%ah
8010397d:	75 52                	jne    801039d1 <mycpu+0x61>
  apicid = lapicid();
8010397f:	e8 3c f0 ff ff       	call   801029c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103984:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010398a:	85 f6                	test   %esi,%esi
  apicid = lapicid();
8010398c:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010398e:	7e 35                	jle    801039c5 <mycpu+0x55>
80103990:	31 d2                	xor    %edx,%edx
80103992:	eb 11                	jmp    801039a5 <mycpu+0x35>
80103994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop
801039a0:	42                   	inc    %edx
801039a1:	39 f2                	cmp    %esi,%edx
801039a3:	74 20                	je     801039c5 <mycpu+0x55>
    if (cpus[i].apicid == apicid)
801039a5:	8d 04 92             	lea    (%edx,%edx,4),%eax
801039a8:	8d 04 42             	lea    (%edx,%eax,2),%eax
801039ab:	c1 e0 04             	shl    $0x4,%eax
801039ae:	0f b6 88 80 27 11 80 	movzbl -0x7feed880(%eax),%ecx
801039b5:	39 d9                	cmp    %ebx,%ecx
801039b7:	75 e7                	jne    801039a0 <mycpu+0x30>
}
801039b9:	83 c4 10             	add    $0x10,%esp
      return &cpus[i];
801039bc:	05 80 27 11 80       	add    $0x80112780,%eax
}
801039c1:	5b                   	pop    %ebx
801039c2:	5e                   	pop    %esi
801039c3:	5d                   	pop    %ebp
801039c4:	c3                   	ret    
  panic("unknown apicid\n");
801039c5:	c7 04 24 67 77 10 80 	movl   $0x80107767,(%esp)
801039cc:	e8 8f c9 ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801039d1:	c7 04 24 98 78 10 80 	movl   $0x80107898,(%esp)
801039d8:	e8 83 c9 ff ff       	call   80100360 <panic>
801039dd:	8d 76 00             	lea    0x0(%esi),%esi

801039e0 <cpuid>:
cpuid() {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039e6:	e8 85 ff ff ff       	call   80103970 <mycpu>
}
801039eb:	c9                   	leave  
  return mycpu()-cpus;
801039ec:	2d 80 27 11 80       	sub    $0x80112780,%eax
801039f1:	c1 f8 04             	sar    $0x4,%eax
801039f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039fa:	c3                   	ret    
801039fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop

80103a00 <myproc>:
myproc(void) {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a07:	e8 94 0b 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103a0c:	e8 5f ff ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103a11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a17:	e8 d4 0b 00 00       	call   801045f0 <popcli>
}
80103a1c:	5a                   	pop    %edx
80103a1d:	89 d8                	mov    %ebx,%eax
80103a1f:	5b                   	pop    %ebx
80103a20:	5d                   	pop    %ebp
80103a21:	c3                   	ret    
80103a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <userinit>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103a37:	e8 e4 fd ff ff       	call   80103820 <allocproc>
  initproc = p;
80103a3c:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  p = allocproc();
80103a41:	89 c3                	mov    %eax,%ebx
  if((p->pgdir = setupkvm()) == 0)
80103a43:	e8 08 35 00 00       	call   80106f50 <setupkvm>
80103a48:	89 43 04             	mov    %eax,0x4(%ebx)
80103a4b:	85 c0                	test   %eax,%eax
80103a4d:	0f 84 cf 00 00 00    	je     80103b22 <userinit+0xf2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a53:	89 04 24             	mov    %eax,(%esp)
80103a56:	b9 60 a4 10 80       	mov    $0x8010a460,%ecx
80103a5b:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103a60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80103a64:	89 54 24 08          	mov    %edx,0x8(%esp)
80103a68:	e8 93 31 00 00       	call   80106c00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a6d:	b8 4c 00 00 00       	mov    $0x4c,%eax
  p->sz = PGSIZE;
80103a72:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a78:	89 44 24 08          	mov    %eax,0x8(%esp)
80103a7c:	31 c0                	xor    %eax,%eax
80103a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a82:	8b 43 18             	mov    0x18(%ebx),%eax
80103a85:	89 04 24             	mov    %eax,(%esp)
80103a88:	e8 13 0d 00 00       	call   801047a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a8d:	8b 43 18             	mov    0x18(%ebx),%eax
80103a90:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a96:	8b 43 18             	mov    0x18(%ebx),%eax
80103a99:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa2:	8b 50 2c             	mov    0x2c(%eax),%edx
80103aa5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103aa9:	8b 43 18             	mov    0x18(%ebx),%eax
80103aac:	8b 50 2c             	mov    0x2c(%eax),%edx
80103aaf:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ab3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab6:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103abd:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ac7:	8b 43 18             	mov    0x18(%ebx),%eax
80103aca:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ad1:	b8 10 00 00 00       	mov    $0x10,%eax
80103ad6:	89 44 24 08          	mov    %eax,0x8(%esp)
80103ada:	b8 90 77 10 80       	mov    $0x80107790,%eax
80103adf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ae3:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ae6:	89 04 24             	mov    %eax,(%esp)
80103ae9:	e8 92 0e 00 00       	call   80104980 <safestrcpy>
  p->cwd = namei("/");
80103aee:	c7 04 24 99 77 10 80 	movl   $0x80107799,(%esp)
80103af5:	e8 76 e6 ff ff       	call   80102170 <namei>
80103afa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103afd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b04:	e8 97 0b 00 00       	call   801046a0 <acquire>
  p->state = RUNNABLE;
80103b09:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b10:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b17:	e8 34 0c 00 00       	call   80104750 <release>
}
80103b1c:	83 c4 14             	add    $0x14,%esp
80103b1f:	5b                   	pop    %ebx
80103b20:	5d                   	pop    %ebp
80103b21:	c3                   	ret    
    panic("userinit: out of memory?");
80103b22:	c7 04 24 77 77 10 80 	movl   $0x80107777,(%esp)
80103b29:	e8 32 c8 ff ff       	call   80100360 <panic>
80103b2e:	66 90                	xchg   %ax,%ax

80103b30 <growproc>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	56                   	push   %esi
80103b34:	53                   	push   %ebx
80103b35:	83 ec 10             	sub    $0x10,%esp
80103b38:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b3b:	e8 60 0a 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103b40:	e8 2b fe ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103b45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4b:	e8 a0 0a 00 00       	call   801045f0 <popcli>
  if(n > 0){
80103b50:	85 f6                	test   %esi,%esi
  sz = curproc->sz;
80103b52:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b54:	7f 1a                	jg     80103b70 <growproc+0x40>
  } else if(n < 0){
80103b56:	75 38                	jne    80103b90 <growproc+0x60>
  curproc->sz = sz;
80103b58:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b5a:	89 1c 24             	mov    %ebx,(%esp)
80103b5d:	e8 9e 2f 00 00       	call   80106b00 <switchuvm>
  return 0;
80103b62:	31 c0                	xor    %eax,%eax
}
80103b64:	83 c4 10             	add    $0x10,%esp
80103b67:	5b                   	pop    %ebx
80103b68:	5e                   	pop    %esi
80103b69:	5d                   	pop    %ebp
80103b6a:	c3                   	ret    
80103b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b74:	01 c6                	add    %eax,%esi
80103b76:	89 74 24 08          	mov    %esi,0x8(%esp)
80103b7a:	8b 43 04             	mov    0x4(%ebx),%eax
80103b7d:	89 04 24             	mov    %eax,(%esp)
80103b80:	e8 db 31 00 00       	call   80106d60 <allocuvm>
80103b85:	85 c0                	test   %eax,%eax
80103b87:	75 cf                	jne    80103b58 <growproc+0x28>
      return -1;
80103b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b8e:	eb d4                	jmp    80103b64 <growproc+0x34>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b94:	01 c6                	add    %eax,%esi
80103b96:	89 74 24 08          	mov    %esi,0x8(%esp)
80103b9a:	8b 43 04             	mov    0x4(%ebx),%eax
80103b9d:	89 04 24             	mov    %eax,(%esp)
80103ba0:	e8 fb 32 00 00       	call   80106ea0 <deallocuvm>
80103ba5:	85 c0                	test   %eax,%eax
80103ba7:	75 af                	jne    80103b58 <growproc+0x28>
80103ba9:	eb de                	jmp    80103b89 <growproc+0x59>
80103bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103baf:	90                   	nop

80103bb0 <fork>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	57                   	push   %edi
80103bb4:	56                   	push   %esi
80103bb5:	53                   	push   %ebx
80103bb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bb9:	e8 e2 09 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103bbe:	e8 ad fd ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103bc3:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103bc9:	e8 22 0a 00 00       	call   801045f0 <popcli>
  if((np = allocproc()) == 0){
80103bce:	e8 4d fc ff ff       	call   80103820 <allocproc>
80103bd3:	85 c0                	test   %eax,%eax
80103bd5:	0f 84 c4 00 00 00    	je     80103c9f <fork+0xef>
80103bdb:	89 c6                	mov    %eax,%esi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bdd:	8b 07                	mov    (%edi),%eax
80103bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103be3:	8b 47 04             	mov    0x4(%edi),%eax
80103be6:	89 04 24             	mov    %eax,(%esp)
80103be9:	e8 42 34 00 00       	call   80107030 <copyuvm>
80103bee:	89 46 04             	mov    %eax,0x4(%esi)
80103bf1:	85 c0                	test   %eax,%eax
80103bf3:	0f 84 ad 00 00 00    	je     80103ca6 <fork+0xf6>
  np->sz = curproc->sz;
80103bf9:	8b 07                	mov    (%edi),%eax
  np->parent = curproc;
80103bfb:	89 7e 14             	mov    %edi,0x14(%esi)
  *np->tf = *curproc->tf;
80103bfe:	8b 4e 18             	mov    0x18(%esi),%ecx
  np->sz = curproc->sz;
80103c01:	89 06                	mov    %eax,(%esi)
  *np->tf = *curproc->tf;
80103c03:	31 c0                	xor    %eax,%eax
80103c05:	8b 5f 18             	mov    0x18(%edi),%ebx
80103c08:	8b 14 03             	mov    (%ebx,%eax,1),%edx
80103c0b:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80103c0e:	83 c0 04             	add    $0x4,%eax
80103c11:	83 f8 4c             	cmp    $0x4c,%eax
80103c14:	72 f2                	jb     80103c08 <fork+0x58>
  np->tf->eax = 0;
80103c16:	8b 46 18             	mov    0x18(%esi),%eax
  for(i = 0; i < NOFILE; i++)
80103c19:	31 db                	xor    %ebx,%ebx
  np->tf->eax = 0;
80103c1b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c30:	8b 44 9f 28          	mov    0x28(%edi,%ebx,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 0c                	je     80103c44 <fork+0x94>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	89 04 24             	mov    %eax,(%esp)
80103c3b:	e8 50 d2 ff ff       	call   80100e90 <filedup>
80103c40:	89 44 9e 28          	mov    %eax,0x28(%esi,%ebx,4)
  for(i = 0; i < NOFILE; i++)
80103c44:	43                   	inc    %ebx
80103c45:	83 fb 10             	cmp    $0x10,%ebx
80103c48:	75 e6                	jne    80103c30 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103c4a:	8b 47 68             	mov    0x68(%edi),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c4d:	83 c7 6c             	add    $0x6c,%edi
  np->cwd = idup(curproc->cwd);
80103c50:	89 04 24             	mov    %eax,(%esp)
80103c53:	e8 78 db ff ff       	call   801017d0 <idup>
80103c58:	89 46 68             	mov    %eax,0x68(%esi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c5b:	b8 10 00 00 00       	mov    $0x10,%eax
80103c60:	89 44 24 08          	mov    %eax,0x8(%esp)
80103c64:	8d 46 6c             	lea    0x6c(%esi),%eax
80103c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103c6b:	89 04 24             	mov    %eax,(%esp)
80103c6e:	e8 0d 0d 00 00       	call   80104980 <safestrcpy>
  pid = np->pid;
80103c73:	8b 5e 10             	mov    0x10(%esi),%ebx
  acquire(&ptable.lock);
80103c76:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c7d:	e8 1e 0a 00 00       	call   801046a0 <acquire>
  np->state = RUNNABLE;
80103c82:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
80103c89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c90:	e8 bb 0a 00 00       	call   80104750 <release>
}
80103c95:	83 c4 1c             	add    $0x1c,%esp
80103c98:	89 d8                	mov    %ebx,%eax
80103c9a:	5b                   	pop    %ebx
80103c9b:	5e                   	pop    %esi
80103c9c:	5f                   	pop    %edi
80103c9d:	5d                   	pop    %ebp
80103c9e:	c3                   	ret    
    return -1;
80103c9f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ca4:	eb ef                	jmp    80103c95 <fork+0xe5>
    kfree(np->kstack);
80103ca6:	8b 46 08             	mov    0x8(%esi),%eax
    return -1;
80103ca9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103cae:	89 04 24             	mov    %eax,(%esp)
80103cb1:	e8 ca e8 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103cb6:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    np->state = UNUSED;
80103cbd:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return -1;
80103cc4:	eb cf                	jmp    80103c95 <fork+0xe5>
80103cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi

80103cd0 <scheduler>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103cd9:	e8 92 fc ff ff       	call   80103970 <mycpu>
  c->proc = 0;
80103cde:	31 d2                	xor    %edx,%edx
80103ce0:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80103ce6:	8d 78 04             	lea    0x4(%eax),%edi
  struct cpu *c = mycpu();
80103ce9:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop
  asm volatile("sti");
80103cf0:	fb                   	sti    
    acquire(&ptable.lock);
80103cf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103cfd:	e8 9e 09 00 00       	call   801046a0 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->state != RUNNABLE)
80103d10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d14:	75 31                	jne    80103d47 <scheduler+0x77>
      c->proc = p;
80103d16:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d1c:	89 1c 24             	mov    %ebx,(%esp)
80103d1f:	e8 dc 2d 00 00       	call   80106b00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d24:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d27:	89 3c 24             	mov    %edi,(%esp)
      p->state = RUNNING;
80103d2a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d31:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d35:	e8 9f 0c 00 00       	call   801049d9 <swtch>
      switchkvm();
80103d3a:	e8 b1 2d 00 00       	call   80106af0 <switchkvm>
      c->proc = 0;
80103d3f:	31 c0                	xor    %eax,%eax
80103d41:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d47:	83 c3 7c             	add    $0x7c,%ebx
80103d4a:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d50:	75 be                	jne    80103d10 <scheduler+0x40>
    release(&ptable.lock);
80103d52:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d59:	e8 f2 09 00 00       	call   80104750 <release>
    sti();
80103d5e:	eb 90                	jmp    80103cf0 <scheduler+0x20>

80103d60 <sched>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	56                   	push   %esi
80103d64:	53                   	push   %ebx
80103d65:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80103d68:	e8 33 08 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103d6d:	e8 fe fb ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103d72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d78:	e8 73 08 00 00       	call   801045f0 <popcli>
  if(!holding(&ptable.lock))
80103d7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d84:	e8 c7 08 00 00       	call   80104650 <holding>
80103d89:	85 c0                	test   %eax,%eax
80103d8b:	74 4f                	je     80103ddc <sched+0x7c>
  if(mycpu()->ncli != 1)
80103d8d:	e8 de fb ff ff       	call   80103970 <mycpu>
80103d92:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d99:	75 65                	jne    80103e00 <sched+0xa0>
  if(p->state == RUNNING)
80103d9b:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d9f:	74 53                	je     80103df4 <sched+0x94>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103da1:	9c                   	pushf  
80103da2:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103da3:	f6 c4 02             	test   $0x2,%ah
80103da6:	75 40                	jne    80103de8 <sched+0x88>
  intena = mycpu()->intena;
80103da8:	e8 c3 fb ff ff       	call   80103970 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dad:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103db0:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103db6:	e8 b5 fb ff ff       	call   80103970 <mycpu>
80103dbb:	8b 40 04             	mov    0x4(%eax),%eax
80103dbe:	89 1c 24             	mov    %ebx,(%esp)
80103dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dc5:	e8 0f 0c 00 00       	call   801049d9 <swtch>
  mycpu()->intena = intena;
80103dca:	e8 a1 fb ff ff       	call   80103970 <mycpu>
80103dcf:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	5b                   	pop    %ebx
80103dd9:	5e                   	pop    %esi
80103dda:	5d                   	pop    %ebp
80103ddb:	c3                   	ret    
    panic("sched ptable.lock");
80103ddc:	c7 04 24 9b 77 10 80 	movl   $0x8010779b,(%esp)
80103de3:	e8 78 c5 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103de8:	c7 04 24 c7 77 10 80 	movl   $0x801077c7,(%esp)
80103def:	e8 6c c5 ff ff       	call   80100360 <panic>
    panic("sched running");
80103df4:	c7 04 24 b9 77 10 80 	movl   $0x801077b9,(%esp)
80103dfb:	e8 60 c5 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103e00:	c7 04 24 ad 77 10 80 	movl   $0x801077ad,(%esp)
80103e07:	e8 54 c5 ff ff       	call   80100360 <panic>
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e10 <exit>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e19:	e8 82 07 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103e1e:	e8 4d fb ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103e23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e29:	e8 c2 07 00 00       	call   801045f0 <popcli>
  if(curproc == initproc)
80103e2e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e34:	0f 84 ec 00 00 00    	je     80103f26 <exit+0x116>
80103e3a:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e3d:	8d 7e 68             	lea    0x68(%esi),%edi
    if(curproc->ofile[fd]){
80103e40:	8b 03                	mov    (%ebx),%eax
80103e42:	85 c0                	test   %eax,%eax
80103e44:	74 0e                	je     80103e54 <exit+0x44>
      fileclose(curproc->ofile[fd]);
80103e46:	89 04 24             	mov    %eax,(%esp)
80103e49:	e8 92 d0 ff ff       	call   80100ee0 <fileclose>
      curproc->ofile[fd] = 0;
80103e4e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  for(fd = 0; fd < NOFILE; fd++){
80103e54:	83 c3 04             	add    $0x4,%ebx
80103e57:	39 df                	cmp    %ebx,%edi
80103e59:	75 e5                	jne    80103e40 <exit+0x30>
  begin_op();
80103e5b:	e8 b0 ef ff ff       	call   80102e10 <begin_op>
  iput(curproc->cwd);
80103e60:	8b 46 68             	mov    0x68(%esi),%eax
80103e63:	89 04 24             	mov    %eax,(%esp)
80103e66:	e8 c5 da ff ff       	call   80101930 <iput>
  end_op();
80103e6b:	e8 10 f0 ff ff       	call   80102e80 <end_op>
  curproc->cwd = 0;
80103e70:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e77:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e7e:	e8 1d 08 00 00       	call   801046a0 <acquire>
  wakeup1(curproc->parent);
80103e83:	8b 56 14             	mov    0x14(%esi),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e86:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e8b:	eb 0d                	jmp    80103e9a <exit+0x8a>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
80103e90:	83 c0 7c             	add    $0x7c,%eax
80103e93:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e98:	74 1c                	je     80103eb6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e9e:	75 f0                	jne    80103e90 <exit+0x80>
80103ea0:	3b 50 20             	cmp    0x20(%eax),%edx
80103ea3:	75 eb                	jne    80103e90 <exit+0x80>
      p->state = RUNNABLE;
80103ea5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eac:	83 c0 7c             	add    $0x7c,%eax
80103eaf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103eb4:	75 e4                	jne    80103e9a <exit+0x8a>
      p->parent = initproc;
80103eb6:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ec1:	eb 18                	jmp    80103edb <exit+0xcb>
80103ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ed0:	83 c2 7c             	add    $0x7c,%edx
80103ed3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103ed9:	74 33                	je     80103f0e <exit+0xfe>
    if(p->parent == curproc){
80103edb:	39 72 14             	cmp    %esi,0x14(%edx)
80103ede:	75 f0                	jne    80103ed0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103ee0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ee4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ee7:	75 e7                	jne    80103ed0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eee:	eb 0a                	jmp    80103efa <exit+0xea>
80103ef0:	83 c0 7c             	add    $0x7c,%eax
80103ef3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ef8:	74 d6                	je     80103ed0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103efa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103efe:	75 f0                	jne    80103ef0 <exit+0xe0>
80103f00:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f03:	75 eb                	jne    80103ef0 <exit+0xe0>
      p->state = RUNNABLE;
80103f05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f0c:	eb e2                	jmp    80103ef0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f0e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f15:	e8 46 fe ff ff       	call   80103d60 <sched>
  panic("zombie exit");
80103f1a:	c7 04 24 e8 77 10 80 	movl   $0x801077e8,(%esp)
80103f21:	e8 3a c4 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103f26:	c7 04 24 db 77 10 80 	movl   $0x801077db,(%esp)
80103f2d:	e8 2e c4 ff ff       	call   80100360 <panic>
80103f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f40 <yield>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	53                   	push   %ebx
80103f44:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f47:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f4e:	e8 4d 07 00 00       	call   801046a0 <acquire>
  pushcli();
80103f53:	e8 48 06 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103f58:	e8 13 fa ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103f5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f63:	e8 88 06 00 00       	call   801045f0 <popcli>
  myproc()->state = RUNNABLE;
80103f68:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f6f:	e8 ec fd ff ff       	call   80103d60 <sched>
  release(&ptable.lock);
80103f74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f7b:	e8 d0 07 00 00       	call   80104750 <release>
}
80103f80:	83 c4 14             	add    $0x14,%esp
80103f83:	5b                   	pop    %ebx
80103f84:	5d                   	pop    %ebp
80103f85:	c3                   	ret    
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi

80103f90 <sleep>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	83 ec 28             	sub    $0x28,%esp
80103f96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80103f99:	89 75 f8             	mov    %esi,-0x8(%ebp)
80103f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80103f9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80103fa2:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80103fa5:	e8 f6 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103faa:	e8 c1 f9 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103faf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb5:	e8 36 06 00 00       	call   801045f0 <popcli>
  if(p == 0)
80103fba:	85 db                	test   %ebx,%ebx
80103fbc:	0f 84 8d 00 00 00    	je     8010404f <sleep+0xbf>
  if(lk == 0)
80103fc2:	85 f6                	test   %esi,%esi
80103fc4:	74 7d                	je     80104043 <sleep+0xb3>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fc6:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103fcc:	74 52                	je     80104020 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fd5:	e8 c6 06 00 00       	call   801046a0 <acquire>
    release(lk);
80103fda:	89 34 24             	mov    %esi,(%esp)
80103fdd:	e8 6e 07 00 00       	call   80104750 <release>
  p->chan = chan;
80103fe2:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fe5:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fec:	e8 6f fd ff ff       	call   80103d60 <sched>
  p->chan = 0;
80103ff1:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ff8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fff:	e8 4c 07 00 00       	call   80104750 <release>
}
80104004:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    acquire(lk);
80104007:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010400a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010400d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104010:	89 ec                	mov    %ebp,%esp
80104012:	5d                   	pop    %ebp
    acquire(lk);
80104013:	e9 88 06 00 00       	jmp    801046a0 <acquire>
80104018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401f:	90                   	nop
  p->chan = chan;
80104020:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104023:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010402a:	e8 31 fd ff ff       	call   80103d60 <sched>
  p->chan = 0;
8010402f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104036:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104039:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010403c:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010403f:	89 ec                	mov    %ebp,%esp
80104041:	5d                   	pop    %ebp
80104042:	c3                   	ret    
    panic("sleep without lk");
80104043:	c7 04 24 fa 77 10 80 	movl   $0x801077fa,(%esp)
8010404a:	e8 11 c3 ff ff       	call   80100360 <panic>
    panic("sleep");
8010404f:	c7 04 24 f4 77 10 80 	movl   $0x801077f4,(%esp)
80104056:	e8 05 c3 ff ff       	call   80100360 <panic>
8010405b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010405f:	90                   	nop

80104060 <wait>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	56                   	push   %esi
80104064:	53                   	push   %ebx
80104065:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80104068:	e8 33 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
8010406d:	e8 fe f8 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104072:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104078:	e8 73 05 00 00       	call   801045f0 <popcli>
  acquire(&ptable.lock);
8010407d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104084:	e8 17 06 00 00       	call   801046a0 <acquire>
    havekids = 0;
80104089:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104090:	eb 19                	jmp    801040ab <wait+0x4b>
80104092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040a0:	83 c3 7c             	add    $0x7c,%ebx
801040a3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801040a9:	74 1b                	je     801040c6 <wait+0x66>
      if(p->parent != curproc)
801040ab:	39 73 14             	cmp    %esi,0x14(%ebx)
801040ae:	75 f0                	jne    801040a0 <wait+0x40>
      if(p->state == ZOMBIE){
801040b0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040b4:	74 3a                	je     801040f0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801040b9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040be:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801040c4:	75 e5                	jne    801040ab <wait+0x4b>
    if(!havekids || curproc->killed){
801040c6:	85 c0                	test   %eax,%eax
801040c8:	74 7b                	je     80104145 <wait+0xe5>
801040ca:	8b 56 24             	mov    0x24(%esi),%edx
801040cd:	85 d2                	test   %edx,%edx
801040cf:	75 74                	jne    80104145 <wait+0xe5>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040d1:	89 34 24             	mov    %esi,(%esp)
801040d4:	b8 20 2d 11 80       	mov    $0x80112d20,%eax
801040d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801040dd:	e8 ae fe ff ff       	call   80103f90 <sleep>
    havekids = 0;
801040e2:	eb a5                	jmp    80104089 <wait+0x29>
801040e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop
        kfree(p->kstack);
801040f0:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
801040f3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040f6:	89 04 24             	mov    %eax,(%esp)
801040f9:	e8 82 e4 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
801040fe:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80104101:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104108:	89 04 24             	mov    %eax,(%esp)
8010410b:	e8 c0 2d 00 00       	call   80106ed0 <freevm>
        release(&ptable.lock);
80104110:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104117:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010411e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104125:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104129:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104130:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104137:	e8 14 06 00 00       	call   80104750 <release>
}
8010413c:	83 c4 10             	add    $0x10,%esp
8010413f:	89 f0                	mov    %esi,%eax
80104141:	5b                   	pop    %ebx
80104142:	5e                   	pop    %esi
80104143:	5d                   	pop    %ebp
80104144:	c3                   	ret    
      release(&ptable.lock);
80104145:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      return -1;
8010414c:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104151:	e8 fa 05 00 00       	call   80104750 <release>
      return -1;
80104156:	eb e4                	jmp    8010413c <wait+0xdc>
80104158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415f:	90                   	nop

80104160 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80104167:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
{
8010416e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104171:	e8 2a 05 00 00       	call   801046a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104176:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010417b:	eb 0d                	jmp    8010418a <wakeup+0x2a>
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
80104180:	83 c0 7c             	add    $0x7c,%eax
80104183:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104188:	74 1c                	je     801041a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010418a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010418e:	75 f0                	jne    80104180 <wakeup+0x20>
80104190:	3b 58 20             	cmp    0x20(%eax),%ebx
80104193:	75 eb                	jne    80104180 <wakeup+0x20>
      p->state = RUNNABLE;
80104195:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419c:	83 c0 7c             	add    $0x7c,%eax
8010419f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801041a4:	75 e4                	jne    8010418a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041a6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041ad:	83 c4 14             	add    $0x14,%esp
801041b0:	5b                   	pop    %ebx
801041b1:	5d                   	pop    %ebp
  release(&ptable.lock);
801041b2:	e9 99 05 00 00       	jmp    80104750 <release>
801041b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041be:	66 90                	xchg   %ax,%ax

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  acquire(&ptable.lock);
801041c7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
{
801041ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041d1:	e8 ca 04 00 00       	call   801046a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041db:	eb 0d                	jmp    801041ea <kill+0x2a>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
801041e0:	83 c0 7c             	add    $0x7c,%eax
801041e3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801041e8:	74 36                	je     80104220 <kill+0x60>
    if(p->pid == pid){
801041ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ed:	75 f1                	jne    801041e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041ef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041fa:	75 07                	jne    80104203 <kill+0x43>
        p->state = RUNNABLE;
801041fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104203:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010420a:	e8 41 05 00 00       	call   80104750 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010420f:	83 c4 14             	add    $0x14,%esp
      return 0;
80104212:	31 c0                	xor    %eax,%eax
}
80104214:	5b                   	pop    %ebx
80104215:	5d                   	pop    %ebp
80104216:	c3                   	ret    
80104217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80104220:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104227:	e8 24 05 00 00       	call   80104750 <release>
}
8010422c:	83 c4 14             	add    $0x14,%esp
  return -1;
8010422f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104234:	5b                   	pop    %ebx
80104235:	5d                   	pop    %ebp
80104236:	c3                   	ret    
80104237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423e:	66 90                	xchg   %ax,%ax

80104240 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010424b:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010424e:	83 ec 4c             	sub    $0x4c,%esp
80104251:	eb 28                	jmp    8010427b <procdump+0x3b>
80104253:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104260:	c7 04 24 2b 78 10 80 	movl   $0x8010782b,(%esp)
80104267:	e8 14 c4 ff ff       	call   80100680 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426c:	83 c3 7c             	add    $0x7c,%ebx
8010426f:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104275:	0f 84 95 00 00 00    	je     80104310 <procdump+0xd0>
    if(p->state == UNUSED)
8010427b:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010427e:	85 c0                	test   %eax,%eax
80104280:	74 ea                	je     8010426c <procdump+0x2c>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104282:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104285:	ba 0b 78 10 80       	mov    $0x8010780b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010428a:	77 11                	ja     8010429d <procdump+0x5d>
8010428c:	8b 14 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%edx
      state = "???";
80104293:	b8 0b 78 10 80       	mov    $0x8010780b,%eax
80104298:	85 d2                	test   %edx,%edx
8010429a:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010429d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801042a1:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801042a4:	89 54 24 08          	mov    %edx,0x8(%esp)
801042a8:	c7 04 24 0f 78 10 80 	movl   $0x8010780f,(%esp)
801042af:	89 44 24 04          	mov    %eax,0x4(%esp)
801042b3:	e8 c8 c3 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
801042b8:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042bc:	75 a2                	jne    80104260 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042be:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801042c5:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042c8:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042cb:	8b 40 0c             	mov    0xc(%eax),%eax
801042ce:	83 c0 08             	add    $0x8,%eax
801042d1:	89 04 24             	mov    %eax,(%esp)
801042d4:	e8 77 02 00 00       	call   80104550 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e0:	8b 17                	mov    (%edi),%edx
801042e2:	85 d2                	test   %edx,%edx
801042e4:	0f 84 76 ff ff ff    	je     80104260 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042ea:	89 54 24 04          	mov    %edx,0x4(%esp)
801042ee:	83 c7 04             	add    $0x4,%edi
801042f1:	c7 04 24 61 72 10 80 	movl   $0x80107261,(%esp)
801042f8:	e8 83 c3 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042fd:	39 fe                	cmp    %edi,%esi
801042ff:	75 df                	jne    801042e0 <procdump+0xa0>
80104301:	e9 5a ff ff ff       	jmp    80104260 <procdump+0x20>
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
  }
}
80104310:	83 c4 4c             	add    $0x4c,%esp
80104313:	5b                   	pop    %ebx
80104314:	5e                   	pop    %esi
80104315:	5f                   	pop    %edi
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop

80104320 <ps>:

int ps()
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 14             	sub    $0x14,%esp
  asm volatile("sti");
80104327:	fb                   	sti    
struct proc *p;
//Enables interrupts on this processor.
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
80104328:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
cprintf("name \t pid \t state \n");
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010432f:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
acquire(&ptable.lock);
80104334:	e8 67 03 00 00       	call   801046a0 <acquire>
cprintf("name \t pid \t state \n");
80104339:	c7 04 24 18 78 10 80 	movl   $0x80107818,(%esp)
80104340:	e8 3b c3 ff ff       	call   80100680 <cprintf>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104345:	eb 1e                	jmp    80104365 <ps+0x45>
80104347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434e:	66 90                	xchg   %ax,%ax
  if(p->state == SLEEPING)
      cprintf("%s \t %d \t SLEEPING \n ", p->name,p->pid);
    else if(p->state == RUNNING)
80104350:	83 f8 04             	cmp    $0x4,%eax
80104353:	74 5b                	je     801043b0 <ps+0x90>
       cprintf("%s \t %d \t RUNNING \n ", p->name,p->pid);
    else if(p->state == RUNNABLE)
80104355:	83 f8 03             	cmp    $0x3,%eax
80104358:	74 76                	je     801043d0 <ps+0xb0>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010435a:	83 c3 7c             	add    $0x7c,%ebx
8010435d:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104363:	74 2d                	je     80104392 <ps+0x72>
  if(p->state == SLEEPING)
80104365:	8b 43 0c             	mov    0xc(%ebx),%eax
80104368:	83 f8 02             	cmp    $0x2,%eax
8010436b:	75 e3                	jne    80104350 <ps+0x30>
      cprintf("%s \t %d \t SLEEPING \n ", p->name,p->pid);
8010436d:	c7 04 24 2d 78 10 80 	movl   $0x8010782d,(%esp)
80104374:	8b 43 10             	mov    0x10(%ebx),%eax
80104377:	89 44 24 08          	mov    %eax,0x8(%esp)
8010437b:	8d 43 6c             	lea    0x6c(%ebx),%eax
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010437e:	83 c3 7c             	add    $0x7c,%ebx
      cprintf("%s \t %d \t SLEEPING \n ", p->name,p->pid);
80104381:	89 44 24 04          	mov    %eax,0x4(%esp)
80104385:	e8 f6 c2 ff ff       	call   80100680 <cprintf>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438a:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104390:	75 d3                	jne    80104365 <ps+0x45>
       cprintf("%s \t %d \t RUNNABLE \n ", p->name,p->pid);
}
release(&ptable.lock);
80104392:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104399:	e8 b2 03 00 00       	call   80104750 <release>
return 22;
}
8010439e:	83 c4 14             	add    $0x14,%esp
801043a1:	b8 16 00 00 00       	mov    $0x16,%eax
801043a6:	5b                   	pop    %ebx
801043a7:	5d                   	pop    %ebp
801043a8:	c3                   	ret    
801043a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
       cprintf("%s \t %d \t RUNNING \n ", p->name,p->pid);
801043b0:	c7 04 24 43 78 10 80 	movl   $0x80107843,(%esp)
801043b7:	8b 43 10             	mov    0x10(%ebx),%eax
801043ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801043be:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801043c5:	e8 b6 c2 ff ff       	call   80100680 <cprintf>
801043ca:	eb 8e                	jmp    8010435a <ps+0x3a>
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       cprintf("%s \t %d \t RUNNABLE \n ", p->name,p->pid);
801043d0:	c7 04 24 58 78 10 80 	movl   $0x80107858,(%esp)
801043d7:	8b 43 10             	mov    0x10(%ebx),%eax
801043da:	89 44 24 08          	mov    %eax,0x8(%esp)
801043de:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801043e5:	e8 96 c2 ff ff       	call   80100680 <cprintf>
801043ea:	e9 6b ff ff ff       	jmp    8010435a <ps+0x3a>
801043ef:	90                   	nop

801043f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043f0:	55                   	push   %ebp
  initlock(&lk->lk, "sleep lock");
801043f1:	b8 d8 78 10 80       	mov    $0x801078d8,%eax
{
801043f6:	89 e5                	mov    %esp,%ebp
801043f8:	53                   	push   %ebx
801043f9:	83 ec 14             	sub    $0x14,%esp
  initlock(&lk->lk, "sleep lock");
801043fc:	89 44 24 04          	mov    %eax,0x4(%esp)
{
80104400:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104403:	8d 43 04             	lea    0x4(%ebx),%eax
80104406:	89 04 24             	mov    %eax,(%esp)
80104409:	e8 22 01 00 00       	call   80104530 <initlock>
  lk->name = name;
8010440e:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104411:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104417:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010441e:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104421:	83 c4 14             	add    $0x14,%esp
80104424:	5b                   	pop    %ebx
80104425:	5d                   	pop    %ebp
80104426:	c3                   	ret    
80104427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442e:	66 90                	xchg   %ax,%ax

80104430 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	83 ec 10             	sub    $0x10,%esp
80104438:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010443b:	8d 73 04             	lea    0x4(%ebx),%esi
8010443e:	89 34 24             	mov    %esi,(%esp)
80104441:	e8 5a 02 00 00       	call   801046a0 <acquire>
  while (lk->locked) {
80104446:	8b 13                	mov    (%ebx),%edx
80104448:	85 d2                	test   %edx,%edx
8010444a:	74 16                	je     80104462 <acquiresleep+0x32>
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104450:	89 74 24 04          	mov    %esi,0x4(%esp)
80104454:	89 1c 24             	mov    %ebx,(%esp)
80104457:	e8 34 fb ff ff       	call   80103f90 <sleep>
  while (lk->locked) {
8010445c:	8b 03                	mov    (%ebx),%eax
8010445e:	85 c0                	test   %eax,%eax
80104460:	75 ee                	jne    80104450 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104462:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104468:	e8 93 f5 ff ff       	call   80103a00 <myproc>
8010446d:	8b 40 10             	mov    0x10(%eax),%eax
80104470:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104473:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104476:	83 c4 10             	add    $0x10,%esp
80104479:	5b                   	pop    %ebx
8010447a:	5e                   	pop    %esi
8010447b:	5d                   	pop    %ebp
  release(&lk->lk);
8010447c:	e9 cf 02 00 00       	jmp    80104750 <release>
80104481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448f:	90                   	nop

80104490 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	83 ec 18             	sub    $0x18,%esp
80104496:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104499:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010449c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  acquire(&lk->lk);
8010449f:	8d 73 04             	lea    0x4(%ebx),%esi
801044a2:	89 34 24             	mov    %esi,(%esp)
801044a5:	e8 f6 01 00 00       	call   801046a0 <acquire>
  lk->locked = 0;
801044aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044b0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044b7:	89 1c 24             	mov    %ebx,(%esp)
801044ba:	e8 a1 fc ff ff       	call   80104160 <wakeup>
  release(&lk->lk);
}
801044bf:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  release(&lk->lk);
801044c2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044c5:	8b 75 fc             	mov    -0x4(%ebp),%esi
801044c8:	89 ec                	mov    %ebp,%esp
801044ca:	5d                   	pop    %ebp
  release(&lk->lk);
801044cb:	e9 80 02 00 00       	jmp    80104750 <release>

801044d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	83 ec 28             	sub    $0x28,%esp
801044d6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801044d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801044df:	89 7d fc             	mov    %edi,-0x4(%ebp)
801044e2:	31 ff                	xor    %edi,%edi
  int r;
  
  acquire(&lk->lk);
801044e4:	8d 73 04             	lea    0x4(%ebx),%esi
801044e7:	89 34 24             	mov    %esi,(%esp)
801044ea:	e8 b1 01 00 00       	call   801046a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044ef:	8b 03                	mov    (%ebx),%eax
801044f1:	85 c0                	test   %eax,%eax
801044f3:	75 1b                	jne    80104510 <holdingsleep+0x40>
  release(&lk->lk);
801044f5:	89 34 24             	mov    %esi,(%esp)
801044f8:	e8 53 02 00 00       	call   80104750 <release>
  return r;
}
801044fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104500:	89 f8                	mov    %edi,%eax
80104502:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104505:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104508:	89 ec                	mov    %ebp,%esp
8010450a:	5d                   	pop    %ebp
8010450b:	c3                   	ret    
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104510:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104513:	e8 e8 f4 ff ff       	call   80103a00 <myproc>
80104518:	39 58 10             	cmp    %ebx,0x10(%eax)
8010451b:	0f 94 c0             	sete   %al
8010451e:	0f b6 f8             	movzbl %al,%edi
80104521:	eb d2                	jmp    801044f5 <holdingsleep+0x25>
80104523:	66 90                	xchg   %ax,%ax
80104525:	66 90                	xchg   %ax,%ax
80104527:	66 90                	xchg   %ax,%ax
80104529:	66 90                	xchg   %ax,%ax
8010452b:	66 90                	xchg   %ax,%ax
8010452d:	66 90                	xchg   %ax,%ax
8010452f:	90                   	nop

80104530 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104536:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010453f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret    
8010454b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010454f:	90                   	nop

80104550 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104550:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104551:	31 d2                	xor    %edx,%edx
{
80104553:	89 e5                	mov    %esp,%ebp
80104555:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104556:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104559:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010455c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010455f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104560:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104566:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010456c:	77 12                	ja     80104580 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010456e:	8b 58 04             	mov    0x4(%eax),%ebx
80104571:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104574:	42                   	inc    %edx
80104575:	83 fa 0a             	cmp    $0xa,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104578:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010457a:	75 e4                	jne    80104560 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010457c:	5b                   	pop    %ebx
8010457d:	5d                   	pop    %ebp
8010457e:	c3                   	ret    
8010457f:	90                   	nop
  for(; i < 10; i++)
80104580:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104583:	8d 51 28             	lea    0x28(%ecx),%edx
80104586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104596:	83 c0 04             	add    $0x4,%eax
80104599:	39 d0                	cmp    %edx,%eax
8010459b:	75 f3                	jne    80104590 <getcallerpcs+0x40>
}
8010459d:	5b                   	pop    %ebx
8010459e:	5d                   	pop    %ebp
8010459f:	c3                   	ret    

801045a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045a7:	9c                   	pushf  
801045a8:	5b                   	pop    %ebx
  asm volatile("cli");
801045a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045aa:	e8 c1 f3 ff ff       	call   80103970 <mycpu>
801045af:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045b5:	85 d2                	test   %edx,%edx
801045b7:	74 17                	je     801045d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045b9:	e8 b2 f3 ff ff       	call   80103970 <mycpu>
801045be:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801045c4:	58                   	pop    %eax
801045c5:	5b                   	pop    %ebx
801045c6:	5d                   	pop    %ebp
801045c7:	c3                   	ret    
801045c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801045d0:	e8 9b f3 ff ff       	call   80103970 <mycpu>
801045d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801045e1:	e8 8a f3 ff ff       	call   80103970 <mycpu>
801045e6:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801045ec:	58                   	pop    %eax
801045ed:	5b                   	pop    %ebx
801045ee:	5d                   	pop    %ebp
801045ef:	c3                   	ret    

801045f0 <popcli>:

void
popcli(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045f6:	9c                   	pushf  
801045f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045f8:	f6 c4 02             	test   $0x2,%ah
801045fb:	75 35                	jne    80104632 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045fd:	e8 6e f3 ff ff       	call   80103970 <mycpu>
80104602:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80104608:	78 34                	js     8010463e <popcli+0x4e>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010460a:	e8 61 f3 ff ff       	call   80103970 <mycpu>
8010460f:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104615:	85 d2                	test   %edx,%edx
80104617:	74 07                	je     80104620 <popcli+0x30>
    sti();
}
80104619:	c9                   	leave  
8010461a:	c3                   	ret    
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104620:	e8 4b f3 ff ff       	call   80103970 <mycpu>
80104625:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010462b:	85 c0                	test   %eax,%eax
8010462d:	74 ea                	je     80104619 <popcli+0x29>
  asm volatile("sti");
8010462f:	fb                   	sti    
}
80104630:	c9                   	leave  
80104631:	c3                   	ret    
    panic("popcli - interruptible");
80104632:	c7 04 24 e3 78 10 80 	movl   $0x801078e3,(%esp)
80104639:	e8 22 bd ff ff       	call   80100360 <panic>
    panic("popcli");
8010463e:	c7 04 24 fa 78 10 80 	movl   $0x801078fa,(%esp)
80104645:	e8 16 bd ff ff       	call   80100360 <panic>
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104650 <holding>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	83 ec 08             	sub    $0x8,%esp
80104656:	89 75 fc             	mov    %esi,-0x4(%ebp)
80104659:	8b 75 08             	mov    0x8(%ebp),%esi
8010465c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010465f:	31 db                	xor    %ebx,%ebx
  pushcli();
80104661:	e8 3a ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104666:	8b 06                	mov    (%esi),%eax
80104668:	85 c0                	test   %eax,%eax
8010466a:	75 14                	jne    80104680 <holding+0x30>
  popcli();
8010466c:	e8 7f ff ff ff       	call   801045f0 <popcli>
}
80104671:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104674:	89 d8                	mov    %ebx,%eax
80104676:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104679:	89 ec                	mov    %ebp,%esp
8010467b:	5d                   	pop    %ebp
8010467c:	c3                   	ret    
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104680:	8b 5e 08             	mov    0x8(%esi),%ebx
80104683:	e8 e8 f2 ff ff       	call   80103970 <mycpu>
80104688:	39 c3                	cmp    %eax,%ebx
8010468a:	0f 94 c3             	sete   %bl
8010468d:	0f b6 db             	movzbl %bl,%ebx
80104690:	eb da                	jmp    8010466c <holding+0x1c>
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <acquire>:
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	83 ec 10             	sub    $0x10,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046a8:	e8 f3 fe ff ff       	call   801045a0 <pushcli>
  if(holding(lk))
801046ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046b0:	89 1c 24             	mov    %ebx,(%esp)
801046b3:	e8 98 ff ff ff       	call   80104650 <holding>
801046b8:	85 c0                	test   %eax,%eax
801046ba:	0f 85 84 00 00 00    	jne    80104744 <acquire+0xa4>
801046c0:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801046c2:	ba 01 00 00 00       	mov    $0x1,%edx
801046c7:	eb 0a                	jmp    801046d3 <acquire+0x33>
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046d3:	89 d0                	mov    %edx,%eax
801046d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046d8:	85 c0                	test   %eax,%eax
801046da:	75 f4                	jne    801046d0 <acquire+0x30>
  __sync_synchronize();
801046dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046e4:	e8 87 f2 ff ff       	call   80103970 <mycpu>
801046e9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046ec:	89 e8                	mov    %ebp,%eax
801046ee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801046f6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801046fc:	77 22                	ja     80104720 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801046fe:	8b 50 04             	mov    0x4(%eax),%edx
80104701:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104705:	46                   	inc    %esi
80104706:	83 fe 0a             	cmp    $0xa,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104709:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010470b:	75 e3                	jne    801046f0 <acquire+0x50>
}
8010470d:	83 c4 10             	add    $0x10,%esp
80104710:	5b                   	pop    %ebx
80104711:	5e                   	pop    %esi
80104712:	5d                   	pop    %ebp
80104713:	c3                   	ret    
80104714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop
  for(; i < 10; i++)
80104720:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104724:	83 c3 34             	add    $0x34,%ebx
80104727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104736:	83 c0 04             	add    $0x4,%eax
80104739:	39 d8                	cmp    %ebx,%eax
8010473b:	75 f3                	jne    80104730 <acquire+0x90>
}
8010473d:	83 c4 10             	add    $0x10,%esp
80104740:	5b                   	pop    %ebx
80104741:	5e                   	pop    %esi
80104742:	5d                   	pop    %ebp
80104743:	c3                   	ret    
    panic("acquire");
80104744:	c7 04 24 01 79 10 80 	movl   $0x80107901,(%esp)
8010474b:	e8 10 bc ff ff       	call   80100360 <panic>

80104750 <release>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 14             	sub    $0x14,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010475a:	89 1c 24             	mov    %ebx,(%esp)
8010475d:	e8 ee fe ff ff       	call   80104650 <holding>
80104762:	85 c0                	test   %eax,%eax
80104764:	74 23                	je     80104789 <release+0x39>
  lk->pcs[0] = 0;
80104766:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010476d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104774:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104779:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010477f:	83 c4 14             	add    $0x14,%esp
80104782:	5b                   	pop    %ebx
80104783:	5d                   	pop    %ebp
  popcli();
80104784:	e9 67 fe ff ff       	jmp    801045f0 <popcli>
    panic("release");
80104789:	c7 04 24 09 79 10 80 	movl   $0x80107909,(%esp)
80104790:	e8 cb bb ff ff       	call   80100360 <panic>
80104795:	66 90                	xchg   %ax,%ax
80104797:	66 90                	xchg   %ax,%ax
80104799:	66 90                	xchg   %ax,%ax
8010479b:	66 90                	xchg   %ax,%ax
8010479d:	66 90                	xchg   %ax,%ax
8010479f:	90                   	nop

801047a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	83 ec 08             	sub    $0x8,%esp
801047a6:	89 7d fc             	mov    %edi,-0x4(%ebp)
801047a9:	8b 55 08             	mov    0x8(%ebp),%edx
801047ac:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801047af:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047b5:	89 d7                	mov    %edx,%edi
801047b7:	09 cf                	or     %ecx,%edi
801047b9:	83 e7 03             	and    $0x3,%edi
801047bc:	75 32                	jne    801047f0 <memset+0x50>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047be:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
801047c1:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047c4:	c1 e0 18             	shl    $0x18,%eax
801047c7:	89 fb                	mov    %edi,%ebx
801047c9:	c1 e3 10             	shl    $0x10,%ebx
801047cc:	09 d8                	or     %ebx,%eax
801047ce:	09 f8                	or     %edi,%eax
801047d0:	c1 e7 08             	shl    $0x8,%edi
801047d3:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047d5:	89 d7                	mov    %edx,%edi
801047d7:	fc                   	cld    
801047d8:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047da:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801047dd:	89 d0                	mov    %edx,%eax
801047df:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047e2:	89 ec                	mov    %ebp,%esp
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801047f0:	89 d7                	mov    %edx,%edi
801047f2:	fc                   	cld    
801047f3:	f3 aa                	rep stos %al,%es:(%edi)
801047f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801047f8:	89 d0                	mov    %edx,%eax
801047fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047fd:	89 ec                	mov    %ebp,%esp
801047ff:	5d                   	pop    %ebp
80104800:	c3                   	ret    
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop

80104810 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	8b 75 10             	mov    0x10(%ebp),%esi
80104817:	53                   	push   %ebx
80104818:	8b 55 08             	mov    0x8(%ebp),%edx
8010481b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010481e:	85 f6                	test   %esi,%esi
80104820:	74 2e                	je     80104850 <memcmp+0x40>
80104822:	01 c6                	add    %eax,%esi
80104824:	eb 10                	jmp    80104836 <memcmp+0x26>
80104826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104830:	40                   	inc    %eax
80104831:	42                   	inc    %edx
  while(n-- > 0){
80104832:	39 f0                	cmp    %esi,%eax
80104834:	74 1a                	je     80104850 <memcmp+0x40>
    if(*s1 != *s2)
80104836:	0f b6 0a             	movzbl (%edx),%ecx
80104839:	0f b6 18             	movzbl (%eax),%ebx
8010483c:	38 d9                	cmp    %bl,%cl
8010483e:	74 f0                	je     80104830 <memcmp+0x20>
      return *s1 - *s2;
80104840:	0f b6 c1             	movzbl %cl,%eax
80104843:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104845:	5b                   	pop    %ebx
80104846:	5e                   	pop    %esi
80104847:	5d                   	pop    %ebp
80104848:	c3                   	ret    
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104850:	5b                   	pop    %ebx
  return 0;
80104851:	31 c0                	xor    %eax,%eax
}
80104853:	5e                   	pop    %esi
80104854:	5d                   	pop    %ebp
80104855:	c3                   	ret    
80104856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	8b 55 08             	mov    0x8(%ebp),%edx
80104867:	56                   	push   %esi
80104868:	8b 75 0c             	mov    0xc(%ebp),%esi
8010486b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010486e:	39 d6                	cmp    %edx,%esi
80104870:	73 2e                	jae    801048a0 <memmove+0x40>
80104872:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104875:	39 fa                	cmp    %edi,%edx
80104877:	73 27                	jae    801048a0 <memmove+0x40>
80104879:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010487c:	85 c9                	test   %ecx,%ecx
8010487e:	74 0d                	je     8010488d <memmove+0x2d>
      *--d = *--s;
80104880:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104884:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104887:	48                   	dec    %eax
80104888:	83 f8 ff             	cmp    $0xffffffff,%eax
8010488b:	75 f3                	jne    80104880 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010488d:	5e                   	pop    %esi
8010488e:	89 d0                	mov    %edx,%eax
80104890:	5f                   	pop    %edi
80104891:	5d                   	pop    %ebp
80104892:	c3                   	ret    
80104893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048a0:	85 c9                	test   %ecx,%ecx
801048a2:	89 d7                	mov    %edx,%edi
801048a4:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801048a7:	74 e4                	je     8010488d <memmove+0x2d>
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048b1:	39 f0                	cmp    %esi,%eax
801048b3:	75 fb                	jne    801048b0 <memmove+0x50>
}
801048b5:	5e                   	pop    %esi
801048b6:	89 d0                	mov    %edx,%eax
801048b8:	5f                   	pop    %edi
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    
801048bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop

801048c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048c0:	eb 9e                	jmp    80104860 <memmove>
801048c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	8b 75 10             	mov    0x10(%ebp),%esi
801048d7:	53                   	push   %ebx
801048d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801048db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801048de:	85 f6                	test   %esi,%esi
801048e0:	74 2e                	je     80104910 <strncmp+0x40>
801048e2:	01 c6                	add    %eax,%esi
801048e4:	eb 14                	jmp    801048fa <strncmp+0x2a>
801048e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
801048f0:	38 ca                	cmp    %cl,%dl
801048f2:	75 10                	jne    80104904 <strncmp+0x34>
    n--, p++, q++;
801048f4:	40                   	inc    %eax
801048f5:	43                   	inc    %ebx
  while(n > 0 && *p && *p == *q)
801048f6:	39 f0                	cmp    %esi,%eax
801048f8:	74 16                	je     80104910 <strncmp+0x40>
801048fa:	0f b6 13             	movzbl (%ebx),%edx
801048fd:	0f b6 08             	movzbl (%eax),%ecx
80104900:	84 d2                	test   %dl,%dl
80104902:	75 ec                	jne    801048f0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104904:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
80104905:	0f b6 c2             	movzbl %dl,%eax
80104908:	29 c8                	sub    %ecx,%eax
}
8010490a:	5e                   	pop    %esi
8010490b:	5d                   	pop    %ebp
8010490c:	c3                   	ret    
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	5b                   	pop    %ebx
    return 0;
80104911:	31 c0                	xor    %eax,%eax
}
80104913:	5e                   	pop    %esi
80104914:	5d                   	pop    %ebp
80104915:	c3                   	ret    
80104916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491d:	8d 76 00             	lea    0x0(%esi),%esi

80104920 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104927:	56                   	push   %esi
80104928:	8b 75 08             	mov    0x8(%ebp),%esi
8010492b:	53                   	push   %ebx
8010492c:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010492f:	89 f2                	mov    %esi,%edx
80104931:	eb 19                	jmp    8010494c <strncpy+0x2c>
80104933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104940:	0f b6 01             	movzbl (%ecx),%eax
80104943:	41                   	inc    %ecx
80104944:	42                   	inc    %edx
80104945:	88 42 ff             	mov    %al,-0x1(%edx)
80104948:	84 c0                	test   %al,%al
8010494a:	74 07                	je     80104953 <strncpy+0x33>
8010494c:	89 fb                	mov    %edi,%ebx
8010494e:	4f                   	dec    %edi
8010494f:	85 db                	test   %ebx,%ebx
80104951:	7f ed                	jg     80104940 <strncpy+0x20>
    ;
  while(n-- > 0)
80104953:	85 ff                	test   %edi,%edi
80104955:	89 d1                	mov    %edx,%ecx
80104957:	7e 17                	jle    80104970 <strncpy+0x50>
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104960:	c6 01 00             	movb   $0x0,(%ecx)
80104963:	41                   	inc    %ecx
  while(n-- > 0)
80104964:	89 c8                	mov    %ecx,%eax
80104966:	f7 d0                	not    %eax
80104968:	01 d0                	add    %edx,%eax
8010496a:	01 d8                	add    %ebx,%eax
8010496c:	85 c0                	test   %eax,%eax
8010496e:	7f f0                	jg     80104960 <strncpy+0x40>
  return os;
}
80104970:	5b                   	pop    %ebx
80104971:	89 f0                	mov    %esi,%eax
80104973:	5e                   	pop    %esi
80104974:	5f                   	pop    %edi
80104975:	5d                   	pop    %ebp
80104976:	c3                   	ret    
80104977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497e:	66 90                	xchg   %ax,%ax

80104980 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	8b 55 10             	mov    0x10(%ebp),%edx
80104987:	53                   	push   %ebx
80104988:	8b 75 08             	mov    0x8(%ebp),%esi
8010498b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010498e:	85 d2                	test   %edx,%edx
80104990:	7e 21                	jle    801049b3 <safestrcpy+0x33>
80104992:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104996:	89 f2                	mov    %esi,%edx
80104998:	eb 12                	jmp    801049ac <safestrcpy+0x2c>
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049a0:	0f b6 08             	movzbl (%eax),%ecx
801049a3:	40                   	inc    %eax
801049a4:	42                   	inc    %edx
801049a5:	88 4a ff             	mov    %cl,-0x1(%edx)
801049a8:	84 c9                	test   %cl,%cl
801049aa:	74 04                	je     801049b0 <safestrcpy+0x30>
801049ac:	39 d8                	cmp    %ebx,%eax
801049ae:	75 f0                	jne    801049a0 <safestrcpy+0x20>
    ;
  *s = 0;
801049b0:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049b3:	5b                   	pop    %ebx
801049b4:	89 f0                	mov    %esi,%eax
801049b6:	5e                   	pop    %esi
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049c0 <strlen>:

int
strlen(const char *s)
{
801049c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049c1:	31 c0                	xor    %eax,%eax
{
801049c3:	89 e5                	mov    %esp,%ebp
801049c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049c8:	80 3a 00             	cmpb   $0x0,(%edx)
801049cb:	74 0a                	je     801049d7 <strlen+0x17>
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
801049d0:	40                   	inc    %eax
801049d1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049d5:	75 f9                	jne    801049d0 <strlen+0x10>
    ;
  return n;
}
801049d7:	5d                   	pop    %ebp
801049d8:	c3                   	ret    

801049d9 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049dd:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049e1:	55                   	push   %ebp
  pushl %ebx
801049e2:	53                   	push   %ebx
  pushl %esi
801049e3:	56                   	push   %esi
  pushl %edi
801049e4:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049e5:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049e7:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049e9:	5f                   	pop    %edi
  popl %esi
801049ea:	5e                   	pop    %esi
  popl %ebx
801049eb:	5b                   	pop    %ebx
  popl %ebp
801049ec:	5d                   	pop    %ebp
  ret
801049ed:	c3                   	ret    
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 04             	sub    $0x4,%esp
801049f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049fa:	e8 01 f0 ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ff:	8b 00                	mov    (%eax),%eax
80104a01:	39 d8                	cmp    %ebx,%eax
80104a03:	76 1b                	jbe    80104a20 <fetchint+0x30>
80104a05:	8d 53 04             	lea    0x4(%ebx),%edx
80104a08:	39 d0                	cmp    %edx,%eax
80104a0a:	72 14                	jb     80104a20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a0f:	8b 13                	mov    (%ebx),%edx
80104a11:	89 10                	mov    %edx,(%eax)
  return 0;
80104a13:	31 c0                	xor    %eax,%eax
}
80104a15:	5a                   	pop    %edx
80104a16:	5b                   	pop    %ebx
80104a17:	5d                   	pop    %ebp
80104a18:	c3                   	ret    
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a25:	eb ee                	jmp    80104a15 <fetchint+0x25>
80104a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 04             	sub    $0x4,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a3a:	e8 c1 ef ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz)
80104a3f:	39 18                	cmp    %ebx,(%eax)
80104a41:	76 2d                	jbe    80104a70 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a43:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a46:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a48:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a4a:	39 d3                	cmp    %edx,%ebx
80104a4c:	73 22                	jae    80104a70 <fetchstr+0x40>
80104a4e:	89 d8                	mov    %ebx,%eax
80104a50:	eb 13                	jmp    80104a65 <fetchstr+0x35>
80104a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a60:	40                   	inc    %eax
80104a61:	39 c2                	cmp    %eax,%edx
80104a63:	76 0b                	jbe    80104a70 <fetchstr+0x40>
    if(*s == 0)
80104a65:	80 38 00             	cmpb   $0x0,(%eax)
80104a68:	75 f6                	jne    80104a60 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a6a:	5a                   	pop    %edx
      return s - *pp;
80104a6b:	29 d8                	sub    %ebx,%eax
}
80104a6d:	5b                   	pop    %ebx
80104a6e:	5d                   	pop    %ebp
80104a6f:	c3                   	ret    
80104a70:	5a                   	pop    %edx
    return -1;
80104a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a76:	5b                   	pop    %ebx
80104a77:	5d                   	pop    %ebp
80104a78:	c3                   	ret    
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a85:	e8 76 ef ff ff       	call   80103a00 <myproc>
80104a8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a8d:	8b 40 18             	mov    0x18(%eax),%eax
80104a90:	8b 40 44             	mov    0x44(%eax),%eax
80104a93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a96:	e8 65 ef ff ff       	call   80103a00 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a9e:	8b 00                	mov    (%eax),%eax
80104aa0:	39 c6                	cmp    %eax,%esi
80104aa2:	73 1c                	jae    80104ac0 <argint+0x40>
80104aa4:	8d 53 08             	lea    0x8(%ebx),%edx
80104aa7:	39 d0                	cmp    %edx,%eax
80104aa9:	72 15                	jb     80104ac0 <argint+0x40>
  *ip = *(int*)(addr);
80104aab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aae:	8b 53 04             	mov    0x4(%ebx),%edx
80104ab1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ab3:	31 c0                	xor    %eax,%eax
}
80104ab5:	5b                   	pop    %ebx
80104ab6:	5e                   	pop    %esi
80104ab7:	5d                   	pop    %ebp
80104ab8:	c3                   	ret    
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac5:	eb ee                	jmp    80104ab5 <argint+0x35>
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	83 ec 20             	sub    $0x20,%esp
80104ad8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104adb:	e8 20 ef ff ff       	call   80103a00 <myproc>
80104ae0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ae2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80104aec:	89 04 24             	mov    %eax,(%esp)
80104aef:	e8 8c ff ff ff       	call   80104a80 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104af4:	c1 e8 1f             	shr    $0x1f,%eax
80104af7:	84 c0                	test   %al,%al
80104af9:	75 35                	jne    80104b30 <argptr+0x60>
80104afb:	89 d8                	mov    %ebx,%eax
80104afd:	c1 e8 1f             	shr    $0x1f,%eax
80104b00:	84 c0                	test   %al,%al
80104b02:	75 2c                	jne    80104b30 <argptr+0x60>
80104b04:	8b 16                	mov    (%esi),%edx
80104b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b09:	39 c2                	cmp    %eax,%edx
80104b0b:	76 23                	jbe    80104b30 <argptr+0x60>
80104b0d:	01 c3                	add    %eax,%ebx
80104b0f:	39 da                	cmp    %ebx,%edx
80104b11:	72 1d                	jb     80104b30 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b16:	89 02                	mov    %eax,(%edx)
  return 0;
80104b18:	31 c0                	xor    %eax,%eax
}
80104b1a:	83 c4 20             	add    $0x20,%esp
80104b1d:	5b                   	pop    %ebx
80104b1e:	5e                   	pop    %esi
80104b1f:	5d                   	pop    %ebp
80104b20:	c3                   	ret    
80104b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b35:	eb e3                	jmp    80104b1a <argptr+0x4a>
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b49:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80104b50:	89 04 24             	mov    %eax,(%esp)
80104b53:	e8 28 ff ff ff       	call   80104a80 <argint>
80104b58:	85 c0                	test   %eax,%eax
80104b5a:	78 14                	js     80104b70 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b66:	89 04 24             	mov    %eax,(%esp)
80104b69:	e8 c2 fe ff ff       	call   80104a30 <fetchstr>
}
80104b6e:	c9                   	leave  
80104b6f:	c3                   	ret    
80104b70:	c9                   	leave  
    return -1;
80104b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b76:	c3                   	ret    
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <syscall>:
[SYS_ps]      sys_ps,
};

void
syscall(void)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 14             	sub    $0x14,%esp
  int num;
  struct proc *curproc = myproc();
80104b87:	e8 74 ee ff ff       	call   80103a00 <myproc>
80104b8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b8e:	8b 40 18             	mov    0x18(%eax),%eax
80104b91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b97:	83 fa 15             	cmp    $0x15,%edx
80104b9a:	77 24                	ja     80104bc0 <syscall+0x40>
80104b9c:	8b 14 85 40 79 10 80 	mov    -0x7fef86c0(,%eax,4),%edx
80104ba3:	85 d2                	test   %edx,%edx
80104ba5:	74 19                	je     80104bc0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ba7:	ff d2                	call   *%edx
80104ba9:	89 c2                	mov    %eax,%edx
80104bab:	8b 43 18             	mov    0x18(%ebx),%eax
80104bae:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bb1:	83 c4 14             	add    $0x14,%esp
80104bb4:	5b                   	pop    %ebx
80104bb5:	5d                   	pop    %ebp
80104bb6:	c3                   	ret    
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104bc0:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104bc4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104bc7:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104bcb:	8b 43 10             	mov    0x10(%ebx),%eax
80104bce:	c7 04 24 11 79 10 80 	movl   $0x80107911,(%esp)
80104bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bd9:	e8 a2 ba ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104bde:	8b 43 18             	mov    0x18(%ebx),%eax
80104be1:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104be8:	83 c4 14             	add    $0x14,%esp
80104beb:	5b                   	pop    %ebx
80104bec:	5d                   	pop    %ebp
80104bed:	c3                   	ret    
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bf0:	55                   	push   %ebp
80104bf1:	0f bf d2             	movswl %dx,%edx
80104bf4:	89 e5                	mov    %esp,%ebp
80104bf6:	0f bf c9             	movswl %cx,%ecx
80104bf9:	57                   	push   %edi
80104bfa:	56                   	push   %esi
80104bfb:	53                   	push   %ebx
80104bfc:	83 ec 3c             	sub    $0x3c,%esp
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bff:	89 04 24             	mov    %eax,(%esp)
{
80104c02:	0f bf 7d 08          	movswl 0x8(%ebp),%edi
80104c06:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c09:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c0c:	89 7d cc             	mov    %edi,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c0f:	8d 7d da             	lea    -0x26(%ebp),%edi
80104c12:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c16:	e8 75 d5 ff ff       	call   80102190 <nameiparent>
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	0f 84 2d 01 00 00    	je     80104d50 <create+0x160>
    return 0;
  ilock(dp);
80104c23:	89 04 24             	mov    %eax,(%esp)
80104c26:	89 c3                	mov    %eax,%ebx
80104c28:	e8 d3 cb ff ff       	call   80101800 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c2d:	31 c9                	xor    %ecx,%ecx
80104c2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80104c33:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c37:	89 1c 24             	mov    %ebx,(%esp)
80104c3a:	e8 71 d1 ff ff       	call   80101db0 <dirlookup>
80104c3f:	85 c0                	test   %eax,%eax
80104c41:	89 c6                	mov    %eax,%esi
80104c43:	74 4b                	je     80104c90 <create+0xa0>
    iunlockput(dp);
80104c45:	89 1c 24             	mov    %ebx,(%esp)
80104c48:	e8 53 ce ff ff       	call   80101aa0 <iunlockput>
    ilock(ip);
80104c4d:	89 34 24             	mov    %esi,(%esp)
80104c50:	e8 ab cb ff ff       	call   80101800 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c55:	83 7d d4 02          	cmpl   $0x2,-0x2c(%ebp)
80104c59:	75 15                	jne    80104c70 <create+0x80>
80104c5b:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c60:	75 0e                	jne    80104c70 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c62:	83 c4 3c             	add    $0x3c,%esp
80104c65:	89 f0                	mov    %esi,%eax
80104c67:	5b                   	pop    %ebx
80104c68:	5e                   	pop    %esi
80104c69:	5f                   	pop    %edi
80104c6a:	5d                   	pop    %ebp
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104c70:	89 34 24             	mov    %esi,(%esp)
    return 0;
80104c73:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c75:	e8 26 ce ff ff       	call   80101aa0 <iunlockput>
}
80104c7a:	83 c4 3c             	add    $0x3c,%esp
80104c7d:	89 f0                	mov    %esi,%eax
80104c7f:	5b                   	pop    %ebx
80104c80:	5e                   	pop    %esi
80104c81:	5f                   	pop    %edi
80104c82:	5d                   	pop    %ebp
80104c83:	c3                   	ret    
80104c84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c97:	8b 03                	mov    (%ebx),%eax
80104c99:	89 04 24             	mov    %eax,(%esp)
80104c9c:	e8 df c9 ff ff       	call   80101680 <ialloc>
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	89 c6                	mov    %eax,%esi
80104ca5:	0f 84 bd 00 00 00    	je     80104d68 <create+0x178>
  ilock(ip);
80104cab:	89 04 24             	mov    %eax,(%esp)
80104cae:	e8 4d cb ff ff       	call   80101800 <ilock>
  ip->major = major;
80104cb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  ip->nlink = 1;
80104cb6:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  ip->major = major;
80104cbc:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104cc3:	66 89 46 54          	mov    %ax,0x54(%esi)
  iupdate(ip);
80104cc7:	89 34 24             	mov    %esi,(%esp)
80104cca:	e8 71 ca ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ccf:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
80104cd3:	74 2b                	je     80104d00 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104cd5:	8b 46 04             	mov    0x4(%esi),%eax
80104cd8:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104cdc:	89 1c 24             	mov    %ebx,(%esp)
80104cdf:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ce3:	e8 a8 d3 ff ff       	call   80102090 <dirlink>
80104ce8:	85 c0                	test   %eax,%eax
80104cea:	78 70                	js     80104d5c <create+0x16c>
  iunlockput(dp);
80104cec:	89 1c 24             	mov    %ebx,(%esp)
80104cef:	e8 ac cd ff ff       	call   80101aa0 <iunlockput>
}
80104cf4:	83 c4 3c             	add    $0x3c,%esp
80104cf7:	89 f0                	mov    %esi,%eax
80104cf9:	5b                   	pop    %ebx
80104cfa:	5e                   	pop    %esi
80104cfb:	5f                   	pop    %edi
80104cfc:	5d                   	pop    %ebp
80104cfd:	c3                   	ret    
80104cfe:	66 90                	xchg   %ax,%ax
    dp->nlink++;  // for ".."
80104d00:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80104d04:	89 1c 24             	mov    %ebx,(%esp)
80104d07:	e8 34 ca ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d0c:	8b 46 04             	mov    0x4(%esi),%eax
80104d0f:	ba b8 79 10 80       	mov    $0x801079b8,%edx
80104d14:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d18:	89 34 24             	mov    %esi,(%esp)
80104d1b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d1f:	e8 6c d3 ff ff       	call   80102090 <dirlink>
80104d24:	85 c0                	test   %eax,%eax
80104d26:	78 1c                	js     80104d44 <create+0x154>
80104d28:	8b 43 04             	mov    0x4(%ebx),%eax
80104d2b:	89 34 24             	mov    %esi,(%esp)
80104d2e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d32:	b8 b7 79 10 80       	mov    $0x801079b7,%eax
80104d37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d3b:	e8 50 d3 ff ff       	call   80102090 <dirlink>
80104d40:	85 c0                	test   %eax,%eax
80104d42:	79 91                	jns    80104cd5 <create+0xe5>
      panic("create dots");
80104d44:	c7 04 24 ab 79 10 80 	movl   $0x801079ab,(%esp)
80104d4b:	e8 10 b6 ff ff       	call   80100360 <panic>
}
80104d50:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104d53:	31 f6                	xor    %esi,%esi
}
80104d55:	5b                   	pop    %ebx
80104d56:	89 f0                	mov    %esi,%eax
80104d58:	5e                   	pop    %esi
80104d59:	5f                   	pop    %edi
80104d5a:	5d                   	pop    %ebp
80104d5b:	c3                   	ret    
    panic("create: dirlink");
80104d5c:	c7 04 24 ba 79 10 80 	movl   $0x801079ba,(%esp)
80104d63:	e8 f8 b5 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104d68:	c7 04 24 9c 79 10 80 	movl   $0x8010799c,(%esp)
80104d6f:	e8 ec b5 ff ff       	call   80100360 <panic>
80104d74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop

80104d80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	89 d6                	mov    %edx,%esi
80104d86:	53                   	push   %ebx
80104d87:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d8c:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d9a:	e8 e1 fc ff ff       	call   80104a80 <argint>
80104d9f:	85 c0                	test   %eax,%eax
80104da1:	78 2d                	js     80104dd0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104da3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104da7:	77 27                	ja     80104dd0 <argfd.constprop.0+0x50>
80104da9:	e8 52 ec ff ff       	call   80103a00 <myproc>
80104dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104db1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104db5:	85 c0                	test   %eax,%eax
80104db7:	74 17                	je     80104dd0 <argfd.constprop.0+0x50>
  if(pfd)
80104db9:	85 db                	test   %ebx,%ebx
80104dbb:	74 02                	je     80104dbf <argfd.constprop.0+0x3f>
    *pfd = fd;
80104dbd:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104dbf:	89 06                	mov    %eax,(%esi)
  return 0;
80104dc1:	31 c0                	xor    %eax,%eax
}
80104dc3:	83 c4 20             	add    $0x20,%esp
80104dc6:	5b                   	pop    %ebx
80104dc7:	5e                   	pop    %esi
80104dc8:	5d                   	pop    %ebp
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd5:	eb ec                	jmp    80104dc3 <argfd.constprop.0+0x43>
80104dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <sys_dup>:
{
80104de0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	56                   	push   %esi
80104de6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104de7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dea:	83 ec 20             	sub    $0x20,%esp
  if(argfd(0, 0, &f) < 0)
80104ded:	e8 8e ff ff ff       	call   80104d80 <argfd.constprop.0>
80104df2:	85 c0                	test   %eax,%eax
80104df4:	78 18                	js     80104e0e <sys_dup+0x2e>
  if((fd=fdalloc(f)) < 0)
80104df6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104df9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dfb:	e8 00 ec ff ff       	call   80103a00 <myproc>
    if(curproc->ofile[fd] == 0){
80104e00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e04:	85 d2                	test   %edx,%edx
80104e06:	74 18                	je     80104e20 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104e08:	43                   	inc    %ebx
80104e09:	83 fb 10             	cmp    $0x10,%ebx
80104e0c:	75 f2                	jne    80104e00 <sys_dup+0x20>
}
80104e0e:	83 c4 20             	add    $0x20,%esp
    return -1;
80104e11:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e16:	89 d8                	mov    %ebx,%eax
80104e18:	5b                   	pop    %ebx
80104e19:	5e                   	pop    %esi
80104e1a:	5d                   	pop    %ebp
80104e1b:	c3                   	ret    
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104e20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e27:	89 04 24             	mov    %eax,(%esp)
80104e2a:	e8 61 c0 ff ff       	call   80100e90 <filedup>
}
80104e2f:	83 c4 20             	add    $0x20,%esp
80104e32:	89 d8                	mov    %ebx,%eax
80104e34:	5b                   	pop    %ebx
80104e35:	5e                   	pop    %esi
80104e36:	5d                   	pop    %ebp
80104e37:	c3                   	ret    
80104e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop

80104e40 <sys_read>:
{
80104e40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e41:	31 c0                	xor    %eax,%eax
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e4b:	e8 30 ff ff ff       	call   80104d80 <argfd.constprop.0>
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 5c                	js     80104eb0 <sys_read+0x70>
80104e54:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e62:	e8 19 fc ff ff       	call   80104a80 <argint>
80104e67:	85 c0                	test   %eax,%eax
80104e69:	78 45                	js     80104eb0 <sys_read+0x70>
80104e6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e75:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e80:	e8 4b fc ff ff       	call   80104ad0 <argptr>
80104e85:	85 c0                	test   %eax,%eax
80104e87:	78 27                	js     80104eb0 <sys_read+0x70>
  return fileread(f, p, n);
80104e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e9a:	89 04 24             	mov    %eax,(%esp)
80104e9d:	e8 7e c1 ff ff       	call   80101020 <fileread>
}
80104ea2:	c9                   	leave  
80104ea3:	c3                   	ret    
80104ea4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eaf:	90                   	nop
80104eb0:	c9                   	leave  
    return -1;
80104eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb6:	c3                   	ret    
80104eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <sys_write>:
{
80104ec0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ecb:	e8 b0 fe ff ff       	call   80104d80 <argfd.constprop.0>
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 5c                	js     80104f30 <sys_write+0x70>
80104ed4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104edb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ede:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ee2:	e8 99 fb ff ff       	call   80104a80 <argint>
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	78 45                	js     80104f30 <sys_write+0x70>
80104eeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ef5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ef9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104efc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f00:	e8 cb fb ff ff       	call   80104ad0 <argptr>
80104f05:	85 c0                	test   %eax,%eax
80104f07:	78 27                	js     80104f30 <sys_write+0x70>
  return filewrite(f, p, n);
80104f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f1a:	89 04 24             	mov    %eax,(%esp)
80104f1d:	e8 be c1 ff ff       	call   801010e0 <filewrite>
}
80104f22:	c9                   	leave  
80104f23:	c3                   	ret    
80104f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f2f:	90                   	nop
80104f30:	c9                   	leave  
    return -1;
80104f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f36:	c3                   	ret    
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <sys_close>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104f46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f4c:	e8 2f fe ff ff       	call   80104d80 <argfd.constprop.0>
80104f51:	85 c0                	test   %eax,%eax
80104f53:	78 2b                	js     80104f80 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f55:	e8 a6 ea ff ff       	call   80103a00 <myproc>
80104f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f5d:	31 c9                	xor    %ecx,%ecx
80104f5f:	89 4c 90 28          	mov    %ecx,0x28(%eax,%edx,4)
  fileclose(f);
80104f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f66:	89 04 24             	mov    %eax,(%esp)
80104f69:	e8 72 bf ff ff       	call   80100ee0 <fileclose>
  return 0;
80104f6e:	31 c0                	xor    %eax,%eax
}
80104f70:	c9                   	leave  
80104f71:	c3                   	ret    
80104f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f80:	c9                   	leave  
    return -1;
80104f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f86:	c3                   	ret    
80104f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <sys_fstat>:
{
80104f90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f91:	31 c0                	xor    %eax,%eax
{
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f9b:	e8 e0 fd ff ff       	call   80104d80 <argfd.constprop.0>
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	78 3c                	js     80104fe0 <sys_fstat+0x50>
80104fa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fab:	b8 14 00 00 00       	mov    $0x14,%eax
80104fb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fbb:	e8 10 fb ff ff       	call   80104ad0 <argptr>
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	78 1c                	js     80104fe0 <sys_fstat+0x50>
  return filestat(f, st);
80104fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fce:	89 04 24             	mov    %eax,(%esp)
80104fd1:	e8 fa bf ff ff       	call   80100fd0 <filestat>
}
80104fd6:	c9                   	leave  
80104fd7:	c3                   	ret    
80104fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdf:	90                   	nop
80104fe0:	c9                   	leave  
    return -1;
80104fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe6:	c3                   	ret    
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <sys_link>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ff6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ff9:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105007:	e8 34 fb ff ff       	call   80104b40 <argstr>
8010500c:	85 c0                	test   %eax,%eax
8010500e:	0f 88 e5 00 00 00    	js     801050f9 <sys_link+0x109>
80105014:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010501b:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010501e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105022:	e8 19 fb ff ff       	call   80104b40 <argstr>
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 ca 00 00 00    	js     801050f9 <sys_link+0x109>
  begin_op();
8010502f:	e8 dc dd ff ff       	call   80102e10 <begin_op>
  if((ip = namei(old)) == 0){
80105034:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105037:	89 04 24             	mov    %eax,(%esp)
8010503a:	e8 31 d1 ff ff       	call   80102170 <namei>
8010503f:	85 c0                	test   %eax,%eax
80105041:	89 c3                	mov    %eax,%ebx
80105043:	0f 84 ab 00 00 00    	je     801050f4 <sys_link+0x104>
  ilock(ip);
80105049:	89 04 24             	mov    %eax,(%esp)
8010504c:	e8 af c7 ff ff       	call   80101800 <ilock>
  if(ip->type == T_DIR){
80105051:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105056:	0f 84 90 00 00 00    	je     801050ec <sys_link+0xfc>
  ip->nlink++;
8010505c:	66 ff 43 56          	incw   0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105060:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105063:	89 1c 24             	mov    %ebx,(%esp)
80105066:	e8 d5 c6 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
8010506b:	89 1c 24             	mov    %ebx,(%esp)
8010506e:	e8 6d c8 ff ff       	call   801018e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105073:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105076:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010507a:	89 04 24             	mov    %eax,(%esp)
8010507d:	e8 0e d1 ff ff       	call   80102190 <nameiparent>
80105082:	85 c0                	test   %eax,%eax
80105084:	89 c6                	mov    %eax,%esi
80105086:	74 50                	je     801050d8 <sys_link+0xe8>
  ilock(dp);
80105088:	89 04 24             	mov    %eax,(%esp)
8010508b:	e8 70 c7 ff ff       	call   80101800 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105090:	8b 03                	mov    (%ebx),%eax
80105092:	39 06                	cmp    %eax,(%esi)
80105094:	75 3a                	jne    801050d0 <sys_link+0xe0>
80105096:	8b 43 04             	mov    0x4(%ebx),%eax
80105099:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010509d:	89 34 24             	mov    %esi,(%esp)
801050a0:	89 44 24 08          	mov    %eax,0x8(%esp)
801050a4:	e8 e7 cf ff ff       	call   80102090 <dirlink>
801050a9:	85 c0                	test   %eax,%eax
801050ab:	78 23                	js     801050d0 <sys_link+0xe0>
  iunlockput(dp);
801050ad:	89 34 24             	mov    %esi,(%esp)
801050b0:	e8 eb c9 ff ff       	call   80101aa0 <iunlockput>
  iput(ip);
801050b5:	89 1c 24             	mov    %ebx,(%esp)
801050b8:	e8 73 c8 ff ff       	call   80101930 <iput>
  end_op();
801050bd:	e8 be dd ff ff       	call   80102e80 <end_op>
  return 0;
801050c2:	31 c0                	xor    %eax,%eax
}
801050c4:	83 c4 3c             	add    $0x3c,%esp
801050c7:	5b                   	pop    %ebx
801050c8:	5e                   	pop    %esi
801050c9:	5f                   	pop    %edi
801050ca:	5d                   	pop    %ebp
801050cb:	c3                   	ret    
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
801050d0:	89 34 24             	mov    %esi,(%esp)
801050d3:	e8 c8 c9 ff ff       	call   80101aa0 <iunlockput>
  ilock(ip);
801050d8:	89 1c 24             	mov    %ebx,(%esp)
801050db:	e8 20 c7 ff ff       	call   80101800 <ilock>
  ip->nlink--;
801050e0:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801050e4:	89 1c 24             	mov    %ebx,(%esp)
801050e7:	e8 54 c6 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
801050ec:	89 1c 24             	mov    %ebx,(%esp)
801050ef:	e8 ac c9 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801050f4:	e8 87 dd ff ff       	call   80102e80 <end_op>
  return -1;
801050f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fe:	eb c4                	jmp    801050c4 <sys_link+0xd4>

80105100 <sys_unlink>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
80105105:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105106:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105109:	83 ec 4c             	sub    $0x4c,%esp
  if(argstr(0, &path) < 0)
8010510c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105117:	e8 24 fa ff ff       	call   80104b40 <argstr>
8010511c:	85 c0                	test   %eax,%eax
8010511e:	0f 88 69 01 00 00    	js     8010528d <sys_unlink+0x18d>
  begin_op();
80105124:	e8 e7 dc ff ff       	call   80102e10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105129:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010512c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010512f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105133:	89 04 24             	mov    %eax,(%esp)
80105136:	e8 55 d0 ff ff       	call   80102190 <nameiparent>
8010513b:	85 c0                	test   %eax,%eax
8010513d:	89 c6                	mov    %eax,%esi
8010513f:	0f 84 43 01 00 00    	je     80105288 <sys_unlink+0x188>
  ilock(dp);
80105145:	89 04 24             	mov    %eax,(%esp)
80105148:	e8 b3 c6 ff ff       	call   80101800 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010514d:	b8 b8 79 10 80       	mov    $0x801079b8,%eax
80105152:	89 44 24 04          	mov    %eax,0x4(%esp)
80105156:	89 1c 24             	mov    %ebx,(%esp)
80105159:	e8 22 cc ff ff       	call   80101d80 <namecmp>
8010515e:	85 c0                	test   %eax,%eax
80105160:	0f 84 1a 01 00 00    	je     80105280 <sys_unlink+0x180>
80105166:	89 1c 24             	mov    %ebx,(%esp)
80105169:	b8 b7 79 10 80       	mov    $0x801079b7,%eax
8010516e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105172:	e8 09 cc ff ff       	call   80101d80 <namecmp>
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 84 01 01 00 00    	je     80105280 <sys_unlink+0x180>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010517f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105183:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105186:	89 44 24 08          	mov    %eax,0x8(%esp)
8010518a:	89 34 24             	mov    %esi,(%esp)
8010518d:	e8 1e cc ff ff       	call   80101db0 <dirlookup>
80105192:	85 c0                	test   %eax,%eax
80105194:	89 c3                	mov    %eax,%ebx
80105196:	0f 84 e4 00 00 00    	je     80105280 <sys_unlink+0x180>
  ilock(ip);
8010519c:	89 04 24             	mov    %eax,(%esp)
8010519f:	e8 5c c6 ff ff       	call   80101800 <ilock>
  if(ip->nlink < 1)
801051a4:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051a9:	0f 8e 1a 01 00 00    	jle    801052c9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051af:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b4:	8d 55 d8             	lea    -0x28(%ebp),%edx
801051b7:	74 77                	je     80105230 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
801051b9:	89 14 24             	mov    %edx,(%esp)
801051bc:	31 c9                	xor    %ecx,%ecx
801051be:	b8 10 00 00 00       	mov    $0x10,%eax
801051c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051c7:	bf 10 00 00 00       	mov    $0x10,%edi
  memset(&de, 0, sizeof(de));
801051cc:	89 44 24 08          	mov    %eax,0x8(%esp)
801051d0:	e8 cb f5 ff ff       	call   801047a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801051d8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801051db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801051df:	89 54 24 04          	mov    %edx,0x4(%esp)
801051e3:	89 34 24             	mov    %esi,(%esp)
801051e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801051ea:	e8 31 ca ff ff       	call   80101c20 <writei>
801051ef:	83 f8 10             	cmp    $0x10,%eax
801051f2:	0f 85 c5 00 00 00    	jne    801052bd <sys_unlink+0x1bd>
  if(ip->type == T_DIR){
801051f8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051fd:	0f 84 9d 00 00 00    	je     801052a0 <sys_unlink+0x1a0>
  iunlockput(dp);
80105203:	89 34 24             	mov    %esi,(%esp)
80105206:	e8 95 c8 ff ff       	call   80101aa0 <iunlockput>
  ip->nlink--;
8010520b:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
8010520f:	89 1c 24             	mov    %ebx,(%esp)
80105212:	e8 29 c5 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105217:	89 1c 24             	mov    %ebx,(%esp)
8010521a:	e8 81 c8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
8010521f:	e8 5c dc ff ff       	call   80102e80 <end_op>
  return 0;
80105224:	31 c0                	xor    %eax,%eax
}
80105226:	83 c4 4c             	add    $0x4c,%esp
80105229:	5b                   	pop    %ebx
8010522a:	5e                   	pop    %esi
8010522b:	5f                   	pop    %edi
8010522c:	5d                   	pop    %ebp
8010522d:	c3                   	ret    
8010522e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105230:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105234:	76 83                	jbe    801051b9 <sys_unlink+0xb9>
80105236:	bf 20 00 00 00       	mov    $0x20,%edi
8010523b:	eb 0f                	jmp    8010524c <sys_unlink+0x14c>
8010523d:	8d 76 00             	lea    0x0(%esi),%esi
80105240:	83 c7 10             	add    $0x10,%edi
80105243:	39 7b 58             	cmp    %edi,0x58(%ebx)
80105246:	0f 86 6d ff ff ff    	jbe    801051b9 <sys_unlink+0xb9>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010524c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105250:	b8 10 00 00 00       	mov    $0x10,%eax
80105255:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105259:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010525d:	89 1c 24             	mov    %ebx,(%esp)
80105260:	e8 8b c8 ff ff       	call   80101af0 <readi>
80105265:	8d 55 d8             	lea    -0x28(%ebp),%edx
80105268:	83 f8 10             	cmp    $0x10,%eax
8010526b:	75 44                	jne    801052b1 <sys_unlink+0x1b1>
    if(de.inum != 0)
8010526d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105272:	74 cc                	je     80105240 <sys_unlink+0x140>
    iunlockput(ip);
80105274:	89 1c 24             	mov    %ebx,(%esp)
80105277:	e8 24 c8 ff ff       	call   80101aa0 <iunlockput>
    goto bad;
8010527c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105280:	89 34 24             	mov    %esi,(%esp)
80105283:	e8 18 c8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105288:	e8 f3 db ff ff       	call   80102e80 <end_op>
  return -1;
8010528d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105292:	eb 92                	jmp    80105226 <sys_unlink+0x126>
80105294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop
    dp->nlink--;
801052a0:	66 ff 4e 56          	decw   0x56(%esi)
    iupdate(dp);
801052a4:	89 34 24             	mov    %esi,(%esp)
801052a7:	e8 94 c4 ff ff       	call   80101740 <iupdate>
801052ac:	e9 52 ff ff ff       	jmp    80105203 <sys_unlink+0x103>
      panic("isdirempty: readi");
801052b1:	c7 04 24 dc 79 10 80 	movl   $0x801079dc,(%esp)
801052b8:	e8 a3 b0 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
801052bd:	c7 04 24 ee 79 10 80 	movl   $0x801079ee,(%esp)
801052c4:	e8 97 b0 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
801052c9:	c7 04 24 ca 79 10 80 	movl   $0x801079ca,(%esp)
801052d0:	e8 8b b0 ff ff       	call   80100360 <panic>
801052d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_open>:

int
sys_open(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052e9:	83 ec 2c             	sub    $0x2c,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801052f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052f7:	e8 44 f8 ff ff       	call   80104b40 <argstr>
801052fc:	85 c0                	test   %eax,%eax
801052fe:	0f 88 7f 00 00 00    	js     80105383 <sys_open+0xa3>
80105304:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010530b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010530e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105312:	e8 69 f7 ff ff       	call   80104a80 <argint>
80105317:	85 c0                	test   %eax,%eax
80105319:	78 68                	js     80105383 <sys_open+0xa3>
    return -1;

  begin_op();
8010531b:	e8 f0 da ff ff       	call   80102e10 <begin_op>

  if(omode & O_CREATE){
80105320:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105324:	75 6a                	jne    80105390 <sys_open+0xb0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105326:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105329:	89 04 24             	mov    %eax,(%esp)
8010532c:	e8 3f ce ff ff       	call   80102170 <namei>
80105331:	85 c0                	test   %eax,%eax
80105333:	89 c6                	mov    %eax,%esi
80105335:	74 47                	je     8010537e <sys_open+0x9e>
      end_op();
      return -1;
    }
    ilock(ip);
80105337:	89 04 24             	mov    %eax,(%esp)
8010533a:	e8 c1 c4 ff ff       	call   80101800 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010533f:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105344:	0f 84 a6 00 00 00    	je     801053f0 <sys_open+0x110>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010534a:	e8 d1 ba ff ff       	call   80100e20 <filealloc>
8010534f:	85 c0                	test   %eax,%eax
80105351:	89 c7                	mov    %eax,%edi
80105353:	74 21                	je     80105376 <sys_open+0x96>
  struct proc *curproc = myproc();
80105355:	e8 a6 e6 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010535a:	31 db                	xor    %ebx,%ebx
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105360:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105364:	85 d2                	test   %edx,%edx
80105366:	74 48                	je     801053b0 <sys_open+0xd0>
  for(fd = 0; fd < NOFILE; fd++){
80105368:	43                   	inc    %ebx
80105369:	83 fb 10             	cmp    $0x10,%ebx
8010536c:	75 f2                	jne    80105360 <sys_open+0x80>
    if(f)
      fileclose(f);
8010536e:	89 3c 24             	mov    %edi,(%esp)
80105371:	e8 6a bb ff ff       	call   80100ee0 <fileclose>
    iunlockput(ip);
80105376:	89 34 24             	mov    %esi,(%esp)
80105379:	e8 22 c7 ff ff       	call   80101aa0 <iunlockput>
    end_op();
8010537e:	e8 fd da ff ff       	call   80102e80 <end_op>
    return -1;
80105383:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105388:	eb 5b                	jmp    801053e5 <sys_open+0x105>
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0);
80105390:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105393:	31 c9                	xor    %ecx,%ecx
80105395:	ba 02 00 00 00       	mov    $0x2,%edx
8010539a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a1:	e8 4a f8 ff ff       	call   80104bf0 <create>
    if(ip == 0){
801053a6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801053a8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053aa:	75 9e                	jne    8010534a <sys_open+0x6a>
801053ac:	eb d0                	jmp    8010537e <sys_open+0x9e>
801053ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801053b0:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  }
  iunlock(ip);
801053b4:	89 34 24             	mov    %esi,(%esp)
801053b7:	e8 24 c5 ff ff       	call   801018e0 <iunlock>
  end_op();
801053bc:	e8 bf da ff ff       	call   80102e80 <end_op>

  f->type = FD_INODE;
801053c1:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
801053c7:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->off = 0;
801053cd:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053d4:	89 d0                	mov    %edx,%eax
801053d6:	f7 d0                	not    %eax
801053d8:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053db:	f6 c2 03             	test   $0x3,%dl
  f->readable = !(omode & O_WRONLY);
801053de:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053e1:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053e5:	83 c4 2c             	add    $0x2c,%esp
801053e8:	89 d8                	mov    %ebx,%eax
801053ea:	5b                   	pop    %ebx
801053eb:	5e                   	pop    %esi
801053ec:	5f                   	pop    %edi
801053ed:	5d                   	pop    %ebp
801053ee:	c3                   	ret    
801053ef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801053f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053f3:	85 c9                	test   %ecx,%ecx
801053f5:	0f 84 4f ff ff ff    	je     8010534a <sys_open+0x6a>
801053fb:	e9 76 ff ff ff       	jmp    80105376 <sys_open+0x96>

80105400 <sys_mkdir>:

int
sys_mkdir(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105406:	e8 05 da ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010540b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105412:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105419:	e8 22 f7 ff ff       	call   80104b40 <argstr>
8010541e:	85 c0                	test   %eax,%eax
80105420:	78 2e                	js     80105450 <sys_mkdir+0x50>
80105422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105425:	31 c9                	xor    %ecx,%ecx
80105427:	ba 01 00 00 00       	mov    $0x1,%edx
8010542c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105433:	e8 b8 f7 ff ff       	call   80104bf0 <create>
80105438:	85 c0                	test   %eax,%eax
8010543a:	74 14                	je     80105450 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543c:	89 04 24             	mov    %eax,(%esp)
8010543f:	e8 5c c6 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105444:	e8 37 da ff ff       	call   80102e80 <end_op>
  return 0;
80105449:	31 c0                	xor    %eax,%eax
}
8010544b:	c9                   	leave  
8010544c:	c3                   	ret    
8010544d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105450:	e8 2b da ff ff       	call   80102e80 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010545a:	c9                   	leave  
8010545b:	c3                   	ret    
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_mknod>:

int
sys_mknod(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105466:	e8 a5 d9 ff ff       	call   80102e10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010546b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010546e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105479:	e8 c2 f6 ff ff       	call   80104b40 <argstr>
8010547e:	85 c0                	test   %eax,%eax
80105480:	78 5e                	js     801054e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105482:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105489:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010548c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105490:	e8 eb f5 ff ff       	call   80104a80 <argint>
  if((argstr(0, &path)) < 0 ||
80105495:	85 c0                	test   %eax,%eax
80105497:	78 47                	js     801054e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105499:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801054a7:	e8 d4 f5 ff ff       	call   80104a80 <argint>
     argint(1, &major) < 0 ||
801054ac:	85 c0                	test   %eax,%eax
801054ae:	78 30                	js     801054e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054b0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054b4:	ba 03 00 00 00       	mov    $0x3,%edx
801054b9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054bd:	89 04 24             	mov    %eax,(%esp)
801054c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054c3:	e8 28 f7 ff ff       	call   80104bf0 <create>
     argint(2, &minor) < 0 ||
801054c8:	85 c0                	test   %eax,%eax
801054ca:	74 14                	je     801054e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054cc:	89 04 24             	mov    %eax,(%esp)
801054cf:	e8 cc c5 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801054d4:	e8 a7 d9 ff ff       	call   80102e80 <end_op>
  return 0;
801054d9:	31 c0                	xor    %eax,%eax
}
801054db:	c9                   	leave  
801054dc:	c3                   	ret    
801054dd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801054e0:	e8 9b d9 ff ff       	call   80102e80 <end_op>
    return -1;
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ea:	c9                   	leave  
801054eb:	c3                   	ret    
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_chdir>:

int
sys_chdir(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054f8:	e8 03 e5 ff ff       	call   80103a00 <myproc>
801054fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054ff:	e8 0c d9 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105504:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105507:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105512:	e8 29 f6 ff ff       	call   80104b40 <argstr>
80105517:	85 c0                	test   %eax,%eax
80105519:	78 4a                	js     80105565 <sys_chdir+0x75>
8010551b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551e:	89 04 24             	mov    %eax,(%esp)
80105521:	e8 4a cc ff ff       	call   80102170 <namei>
80105526:	85 c0                	test   %eax,%eax
80105528:	89 c3                	mov    %eax,%ebx
8010552a:	74 39                	je     80105565 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010552c:	89 04 24             	mov    %eax,(%esp)
8010552f:	e8 cc c2 ff ff       	call   80101800 <ilock>
  if(ip->type != T_DIR){
80105534:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105539:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010553c:	75 22                	jne    80105560 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010553e:	e8 9d c3 ff ff       	call   801018e0 <iunlock>
  iput(curproc->cwd);
80105543:	8b 46 68             	mov    0x68(%esi),%eax
80105546:	89 04 24             	mov    %eax,(%esp)
80105549:	e8 e2 c3 ff ff       	call   80101930 <iput>
  end_op();
8010554e:	e8 2d d9 ff ff       	call   80102e80 <end_op>
  curproc->cwd = ip;
  return 0;
80105553:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105555:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105558:	83 c4 20             	add    $0x20,%esp
8010555b:	5b                   	pop    %ebx
8010555c:	5e                   	pop    %esi
8010555d:	5d                   	pop    %ebp
8010555e:	c3                   	ret    
8010555f:	90                   	nop
    iunlockput(ip);
80105560:	e8 3b c5 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105565:	e8 16 d9 ff ff       	call   80102e80 <end_op>
    return -1;
8010556a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556f:	eb e7                	jmp    80105558 <sys_chdir+0x68>
80105571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop

80105580 <sys_exec>:

int
sys_exec(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105586:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010558c:	81 ec ac 00 00 00    	sub    $0xac,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105592:	89 44 24 04          	mov    %eax,0x4(%esp)
80105596:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010559d:	e8 9e f5 ff ff       	call   80104b40 <argstr>
801055a2:	85 c0                	test   %eax,%eax
801055a4:	0f 88 8e 00 00 00    	js     80105638 <sys_exec+0xb8>
801055aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055b1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055bb:	e8 c0 f4 ff ff       	call   80104a80 <argint>
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 74                	js     80105638 <sys_exec+0xb8>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055c4:	ba 80 00 00 00       	mov    $0x80,%edx
801055c9:	31 c9                	xor    %ecx,%ecx
801055cb:	89 54 24 08          	mov    %edx,0x8(%esp)
801055cf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801055d5:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801055db:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055e1:	89 04 24             	mov    %eax,(%esp)
801055e4:	e8 b7 f1 ff ff       	call   801047a0 <memset>
    if(i >= NELEM(argv))
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
801055f4:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055fa:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105601:	01 f0                	add    %esi,%eax
80105603:	89 04 24             	mov    %eax,(%esp)
80105606:	e8 e5 f3 ff ff       	call   801049f0 <fetchint>
8010560b:	85 c0                	test   %eax,%eax
8010560d:	78 29                	js     80105638 <sys_exec+0xb8>
      return -1;
    if(uarg == 0){
8010560f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105615:	85 c0                	test   %eax,%eax
80105617:	74 37                	je     80105650 <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105619:	89 04 24             	mov    %eax,(%esp)
8010561c:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105622:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105625:	89 54 24 04          	mov    %edx,0x4(%esp)
80105629:	e8 02 f4 ff ff       	call   80104a30 <fetchstr>
8010562e:	85 c0                	test   %eax,%eax
80105630:	78 06                	js     80105638 <sys_exec+0xb8>
  for(i=0;; i++){
80105632:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80105633:	83 fb 20             	cmp    $0x20,%ebx
80105636:	75 b8                	jne    801055f0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
80105638:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
8010563e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105643:	5b                   	pop    %ebx
80105644:	5e                   	pop    %esi
80105645:	5f                   	pop    %edi
80105646:	5d                   	pop    %ebp
80105647:	c3                   	ret    
80105648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564f:	90                   	nop
      argv[i] = 0;
80105650:	31 c0                	xor    %eax,%eax
80105652:	89 84 9d 68 ff ff ff 	mov    %eax,-0x98(%ebp,%ebx,4)
  return exec(path, argv);
80105659:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010565f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105663:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105669:	89 04 24             	mov    %eax,(%esp)
8010566c:	e8 ff b3 ff ff       	call   80100a70 <exec>
}
80105671:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105677:	5b                   	pop    %ebx
80105678:	5e                   	pop    %esi
80105679:	5f                   	pop    %edi
8010567a:	5d                   	pop    %ebp
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_pipe>:

int
sys_pipe(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105684:	bf 08 00 00 00       	mov    $0x8,%edi
{
80105689:	56                   	push   %esi
8010568a:	53                   	push   %ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010568b:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010568e:	83 ec 2c             	sub    $0x2c,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105691:	89 7c 24 08          	mov    %edi,0x8(%esp)
80105695:	89 44 24 04          	mov    %eax,0x4(%esp)
80105699:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056a0:	e8 2b f4 ff ff       	call   80104ad0 <argptr>
801056a5:	85 c0                	test   %eax,%eax
801056a7:	78 4b                	js     801056f4 <sys_pipe+0x74>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056b3:	89 04 24             	mov    %eax,(%esp)
801056b6:	e8 c5 dd ff ff       	call   80103480 <pipealloc>
801056bb:	85 c0                	test   %eax,%eax
801056bd:	78 35                	js     801056f4 <sys_pipe+0x74>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056bf:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056c2:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056c4:	e8 37 e3 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056d0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056d4:	85 f6                	test   %esi,%esi
801056d6:	74 28                	je     80105700 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801056d8:	43                   	inc    %ebx
801056d9:	83 fb 10             	cmp    $0x10,%ebx
801056dc:	75 f2                	jne    801056d0 <sys_pipe+0x50>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801056de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056e1:	89 04 24             	mov    %eax,(%esp)
801056e4:	e8 f7 b7 ff ff       	call   80100ee0 <fileclose>
    fileclose(wf);
801056e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801056ec:	89 04 24             	mov    %eax,(%esp)
801056ef:	e8 ec b7 ff ff       	call   80100ee0 <fileclose>
    return -1;
801056f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f9:	eb 56                	jmp    80105751 <sys_pipe+0xd1>
801056fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop
      curproc->ofile[fd] = f;
80105700:	8d 73 08             	lea    0x8(%ebx),%esi
80105703:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105707:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010570a:	e8 f1 e2 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010570f:	31 d2                	xor    %edx,%edx
80105711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105720:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105724:	85 c9                	test   %ecx,%ecx
80105726:	74 18                	je     80105740 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105728:	42                   	inc    %edx
80105729:	83 fa 10             	cmp    $0x10,%edx
8010572c:	75 f2                	jne    80105720 <sys_pipe+0xa0>
      myproc()->ofile[fd0] = 0;
8010572e:	e8 cd e2 ff ff       	call   80103a00 <myproc>
80105733:	31 d2                	xor    %edx,%edx
80105735:	89 54 b0 08          	mov    %edx,0x8(%eax,%esi,4)
80105739:	eb a3                	jmp    801056de <sys_pipe+0x5e>
8010573b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop
      curproc->ofile[fd] = f;
80105740:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105744:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105747:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105749:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010574c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010574f:	31 c0                	xor    %eax,%eax
}
80105751:	83 c4 2c             	add    $0x2c,%esp
80105754:	5b                   	pop    %ebx
80105755:	5e                   	pop    %esi
80105756:	5f                   	pop    %edi
80105757:	5d                   	pop    %ebp
80105758:	c3                   	ret    
80105759:	66 90                	xchg   %ax,%ax
8010575b:	66 90                	xchg   %ax,%ax
8010575d:	66 90                	xchg   %ax,%ax
8010575f:	90                   	nop

80105760 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105760:	e9 4b e4 ff ff       	jmp    80103bb0 <fork>
80105765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_exit>:
}

int
sys_exit(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 08             	sub    $0x8,%esp
  exit();
80105776:	e8 95 e6 ff ff       	call   80103e10 <exit>
  return 0;  // not reached
}
8010577b:	31 c0                	xor    %eax,%eax
8010577d:	c9                   	leave  
8010577e:	c3                   	ret    
8010577f:	90                   	nop

80105780 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105780:	e9 db e8 ff ff       	jmp    80104060 <wait>
80105785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_kill>:
}

int
sys_kill(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105796:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010579d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a4:	e8 d7 f2 ff ff       	call   80104a80 <argint>
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 13                	js     801057c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b0:	89 04 24             	mov    %eax,(%esp)
801057b3:	e8 08 ea ff ff       	call   801041c0 <kill>
}
801057b8:	c9                   	leave  
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057c0:	c9                   	leave  
    return -1;
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c6:	c3                   	ret    
801057c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <sys_getpid>:

int
sys_getpid(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057d6:	e8 25 e2 ff ff       	call   80103a00 <myproc>
801057db:	8b 40 10             	mov    0x10(%eax),%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    

801057e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057e7:	83 ec 24             	sub    $0x24,%esp
  if(argint(0, &n) < 0)
801057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057f5:	e8 86 f2 ff ff       	call   80104a80 <argint>
801057fa:	85 c0                	test   %eax,%eax
801057fc:	78 22                	js     80105820 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057fe:	e8 fd e1 ff ff       	call   80103a00 <myproc>
80105803:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105808:	89 04 24             	mov    %eax,(%esp)
8010580b:	e8 20 e3 ff ff       	call   80103b30 <growproc>
80105810:	85 c0                	test   %eax,%eax
80105812:	78 0c                	js     80105820 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105814:	83 c4 24             	add    $0x24,%esp
80105817:	89 d8                	mov    %ebx,%eax
80105819:	5b                   	pop    %ebx
8010581a:	5d                   	pop    %ebp
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105820:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105825:	eb ed                	jmp    80105814 <sys_sbrk+0x34>
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <sys_sleep>:

int
sys_sleep(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105837:	83 ec 24             	sub    $0x24,%esp
  if(argint(0, &n) < 0)
8010583a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010583e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105845:	e8 36 f2 ff ff       	call   80104a80 <argint>
8010584a:	85 c0                	test   %eax,%eax
8010584c:	0f 88 82 00 00 00    	js     801058d4 <sys_sleep+0xa4>
    return -1;
  acquire(&tickslock);
80105852:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105859:	e8 42 ee ff ff       	call   801046a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010585e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  ticks0 = ticks;
80105861:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105867:	85 c9                	test   %ecx,%ecx
80105869:	75 26                	jne    80105891 <sys_sleep+0x61>
8010586b:	eb 53                	jmp    801058c0 <sys_sleep+0x90>
8010586d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105870:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
80105877:	b8 60 4c 11 80       	mov    $0x80114c60,%eax
8010587c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105880:	e8 0b e7 ff ff       	call   80103f90 <sleep>
  while(ticks - ticks0 < n){
80105885:	a1 a0 54 11 80       	mov    0x801154a0,%eax
8010588a:	29 d8                	sub    %ebx,%eax
8010588c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010588f:	73 2f                	jae    801058c0 <sys_sleep+0x90>
    if(myproc()->killed){
80105891:	e8 6a e1 ff ff       	call   80103a00 <myproc>
80105896:	8b 50 24             	mov    0x24(%eax),%edx
80105899:	85 d2                	test   %edx,%edx
8010589b:	74 d3                	je     80105870 <sys_sleep+0x40>
      release(&tickslock);
8010589d:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058a4:	e8 a7 ee ff ff       	call   80104750 <release>
  }
  release(&tickslock);
  return 0;
}
801058a9:	83 c4 24             	add    $0x24,%esp
      return -1;
801058ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b1:	5b                   	pop    %ebx
801058b2:	5d                   	pop    %ebp
801058b3:	c3                   	ret    
801058b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058bf:	90                   	nop
  release(&tickslock);
801058c0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058c7:	e8 84 ee ff ff       	call   80104750 <release>
  return 0;
801058cc:	31 c0                	xor    %eax,%eax
}
801058ce:	83 c4 24             	add    $0x24,%esp
801058d1:	5b                   	pop    %ebx
801058d2:	5d                   	pop    %ebp
801058d3:	c3                   	ret    
    return -1;
801058d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d9:	eb f3                	jmp    801058ce <sys_sleep+0x9e>
801058db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop

801058e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
801058e4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801058e7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058ee:	e8 ad ed ff ff       	call   801046a0 <acquire>
  xticks = ticks;
801058f3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801058f9:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105900:	e8 4b ee ff ff       	call   80104750 <release>
  return xticks;
}
80105905:	83 c4 14             	add    $0x14,%esp
80105908:	89 d8                	mov    %ebx,%eax
8010590a:	5b                   	pop    %ebx
8010590b:	5d                   	pop    %ebp
8010590c:	c3                   	ret    
8010590d:	8d 76 00             	lea    0x0(%esi),%esi

80105910 <sys_ps>:
//Processes || Copy elements from the kernel ptable to the user space
extern struct proc * getptable_proc(void);

int sys_ps(void)
{
    return ps();
80105910:	e9 0b ea ff ff       	jmp    80104320 <ps>

80105915 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105915:	1e                   	push   %ds
  pushl %es
80105916:	06                   	push   %es
  pushl %fs
80105917:	0f a0                	push   %fs
  pushl %gs
80105919:	0f a8                	push   %gs
  pushal
8010591b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010591c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105920:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105922:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105924:	54                   	push   %esp
  call trap
80105925:	e8 c6 00 00 00       	call   801059f0 <trap>
  addl $4, %esp
8010592a:	83 c4 04             	add    $0x4,%esp

8010592d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010592d:	61                   	popa   
  popl %gs
8010592e:	0f a9                	pop    %gs
  popl %fs
80105930:	0f a1                	pop    %fs
  popl %es
80105932:	07                   	pop    %es
  popl %ds
80105933:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105934:	83 c4 08             	add    $0x8,%esp
  iret
80105937:	cf                   	iret   
80105938:	66 90                	xchg   %ax,%ax
8010593a:	66 90                	xchg   %ax,%ax
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105940:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105941:	31 c0                	xor    %eax,%eax
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	83 ec 18             	sub    $0x18,%esp
80105948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105950:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105957:	b9 08 00 00 8e       	mov    $0x8e000008,%ecx
8010595c:	89 0c c5 a2 4c 11 80 	mov    %ecx,-0x7feeb35e(,%eax,8)
80105963:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
8010596a:	80 
8010596b:	c1 ea 10             	shr    $0x10,%edx
8010596e:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105975:	80 
  for(i = 0; i < 256; i++)
80105976:	40                   	inc    %eax
80105977:	3d 00 01 00 00       	cmp    $0x100,%eax
8010597c:	75 d2                	jne    80105950 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010597e:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105983:	b9 fd 79 10 80       	mov    $0x801079fd,%ecx
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105988:	ba 08 00 00 ef       	mov    $0xef000008,%edx
  initlock(&tickslock, "time");
8010598d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105991:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105998:	89 15 a2 4e 11 80    	mov    %edx,0x80114ea2
8010599e:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801059a4:	c1 e8 10             	shr    $0x10,%eax
801059a7:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801059ad:	e8 7e eb ff ff       	call   80104530 <initlock>
}
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    
801059b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop

801059c0 <idtinit>:

void
idtinit(void)
{
801059c0:	55                   	push   %ebp
  pd[1] = (uint)p;
801059c1:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801059c6:	89 e5                	mov    %esp,%ebp
801059c8:	0f b7 d0             	movzwl %ax,%edx
  pd[2] = (uint)p >> 16;
801059cb:	c1 e8 10             	shr    $0x10,%eax
801059ce:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801059d1:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801059d7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
801059f6:	83 ec 3c             	sub    $0x3c,%esp
801059f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059fc:	8b 43 30             	mov    0x30(%ebx),%eax
801059ff:	83 f8 40             	cmp    $0x40,%eax
80105a02:	0f 84 f8 01 00 00    	je     80105c00 <trap+0x210>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a08:	83 e8 20             	sub    $0x20,%eax
80105a0b:	83 f8 1f             	cmp    $0x1f,%eax
80105a0e:	77 07                	ja     80105a17 <trap+0x27>
80105a10:	ff 24 85 a4 7a 10 80 	jmp    *-0x7fef855c(,%eax,4)
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a17:	e8 e4 df ff ff       	call   80103a00 <myproc>
80105a1c:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	0f 84 30 02 00 00    	je     80105c57 <trap+0x267>
80105a27:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a2b:	0f 84 26 02 00 00    	je     80105c57 <trap+0x267>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a31:	0f 20 d1             	mov    %cr2,%ecx
80105a34:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a37:	e8 a4 df ff ff       	call   801039e0 <cpuid>
80105a3c:	8b 73 30             	mov    0x30(%ebx),%esi
80105a3f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a42:	8b 43 34             	mov    0x34(%ebx),%eax
80105a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a48:	e8 b3 df ff ff       	call   80103a00 <myproc>
80105a4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a50:	e8 ab df ff ff       	call   80103a00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a55:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a58:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a5c:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a5f:	89 7c 24 18          	mov    %edi,0x18(%esp)
80105a63:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a66:	89 54 24 14          	mov    %edx,0x14(%esp)
80105a6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a6d:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a70:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a74:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a78:	89 54 24 10          	mov    %edx,0x10(%esp)
80105a7c:	8b 40 10             	mov    0x10(%eax),%eax
80105a7f:	c7 04 24 60 7a 10 80 	movl   $0x80107a60,(%esp)
80105a86:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a8a:	e8 f1 ab ff ff       	call   80100680 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a8f:	e8 6c df ff ff       	call   80103a00 <myproc>
80105a94:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a9b:	e8 60 df ff ff       	call   80103a00 <myproc>
80105aa0:	85 c0                	test   %eax,%eax
80105aa2:	74 1b                	je     80105abf <trap+0xcf>
80105aa4:	e8 57 df ff ff       	call   80103a00 <myproc>
80105aa9:	8b 50 24             	mov    0x24(%eax),%edx
80105aac:	85 d2                	test   %edx,%edx
80105aae:	74 0f                	je     80105abf <trap+0xcf>
80105ab0:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105ab3:	83 e0 03             	and    $0x3,%eax
80105ab6:	83 f8 03             	cmp    $0x3,%eax
80105ab9:	0f 84 81 01 00 00    	je     80105c40 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105abf:	e8 3c df ff ff       	call   80103a00 <myproc>
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	74 0f                	je     80105ad7 <trap+0xe7>
80105ac8:	e8 33 df ff ff       	call   80103a00 <myproc>
80105acd:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ad1:	0f 84 09 01 00 00    	je     80105be0 <trap+0x1f0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ad7:	e8 24 df ff ff       	call   80103a00 <myproc>
80105adc:	85 c0                	test   %eax,%eax
80105ade:	66 90                	xchg   %ax,%ax
80105ae0:	74 1b                	je     80105afd <trap+0x10d>
80105ae2:	e8 19 df ff ff       	call   80103a00 <myproc>
80105ae7:	8b 40 24             	mov    0x24(%eax),%eax
80105aea:	85 c0                	test   %eax,%eax
80105aec:	74 0f                	je     80105afd <trap+0x10d>
80105aee:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105af1:	83 e0 03             	and    $0x3,%eax
80105af4:	83 f8 03             	cmp    $0x3,%eax
80105af7:	0f 84 2c 01 00 00    	je     80105c29 <trap+0x239>
    exit();
}
80105afd:	83 c4 3c             	add    $0x3c,%esp
80105b00:	5b                   	pop    %ebx
80105b01:	5e                   	pop    %esi
80105b02:	5f                   	pop    %edi
80105b03:	5d                   	pop    %ebp
80105b04:	c3                   	ret    
    ideintr();
80105b05:	e8 f6 c7 ff ff       	call   80102300 <ideintr>
    lapiceoi();
80105b0a:	e8 d1 ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b0f:	90                   	nop
80105b10:	e8 eb de ff ff       	call   80103a00 <myproc>
80105b15:	85 c0                	test   %eax,%eax
80105b17:	75 8b                	jne    80105aa4 <trap+0xb4>
80105b19:	eb a4                	jmp    80105abf <trap+0xcf>
    if(cpuid() == 0){
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
80105b20:	e8 bb de ff ff       	call   801039e0 <cpuid>
80105b25:	85 c0                	test   %eax,%eax
80105b27:	75 e1                	jne    80105b0a <trap+0x11a>
      acquire(&tickslock);
80105b29:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105b30:	e8 6b eb ff ff       	call   801046a0 <acquire>
      wakeup(&ticks);
80105b35:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105b3c:	ff 05 a0 54 11 80    	incl   0x801154a0
      wakeup(&ticks);
80105b42:	e8 19 e6 ff ff       	call   80104160 <wakeup>
      release(&tickslock);
80105b47:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105b4e:	e8 fd eb ff ff       	call   80104750 <release>
    lapiceoi();
80105b53:	eb b5                	jmp    80105b0a <trap+0x11a>
    kbdintr();
80105b55:	e8 46 cd ff ff       	call   801028a0 <kbdintr>
    lapiceoi();
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b60:	e8 7b ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b65:	e8 96 de ff ff       	call   80103a00 <myproc>
80105b6a:	85 c0                	test   %eax,%eax
80105b6c:	0f 85 32 ff ff ff    	jne    80105aa4 <trap+0xb4>
80105b72:	e9 48 ff ff ff       	jmp    80105abf <trap+0xcf>
    uartintr();
80105b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7e:	66 90                	xchg   %ax,%ax
80105b80:	e8 7b 02 00 00       	call   80105e00 <uartintr>
    lapiceoi();
80105b85:	e8 56 ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b8a:	e8 71 de ff ff       	call   80103a00 <myproc>
80105b8f:	85 c0                	test   %eax,%eax
80105b91:	0f 85 0d ff ff ff    	jne    80105aa4 <trap+0xb4>
80105b97:	e9 23 ff ff ff       	jmp    80105abf <trap+0xcf>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b9c:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b9f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105ba3:	e8 38 de ff ff       	call   801039e0 <cpuid>
80105ba8:	c7 04 24 08 7a 10 80 	movl   $0x80107a08,(%esp)
80105baf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105bb3:	89 74 24 08          	mov    %esi,0x8(%esp)
80105bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bbb:	e8 c0 aa ff ff       	call   80100680 <cprintf>
    lapiceoi();
80105bc0:	e8 1b ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bc5:	e8 36 de ff ff       	call   80103a00 <myproc>
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	0f 85 d2 fe ff ff    	jne    80105aa4 <trap+0xb4>
80105bd2:	e9 e8 fe ff ff       	jmp    80105abf <trap+0xcf>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105be4:	0f 85 ed fe ff ff    	jne    80105ad7 <trap+0xe7>
    yield();
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bf0:	e8 4b e3 ff ff       	call   80103f40 <yield>
80105bf5:	e9 dd fe ff ff       	jmp    80105ad7 <trap+0xe7>
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105c00:	e8 fb dd ff ff       	call   80103a00 <myproc>
80105c05:	8b 70 24             	mov    0x24(%eax),%esi
80105c08:	85 f6                	test   %esi,%esi
80105c0a:	75 44                	jne    80105c50 <trap+0x260>
    myproc()->tf = tf;
80105c0c:	e8 ef dd ff ff       	call   80103a00 <myproc>
80105c11:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c14:	e8 67 ef ff ff       	call   80104b80 <syscall>
    if(myproc()->killed)
80105c19:	e8 e2 dd ff ff       	call   80103a00 <myproc>
80105c1e:	8b 48 24             	mov    0x24(%eax),%ecx
80105c21:	85 c9                	test   %ecx,%ecx
80105c23:	0f 84 d4 fe ff ff    	je     80105afd <trap+0x10d>
}
80105c29:	83 c4 3c             	add    $0x3c,%esp
80105c2c:	5b                   	pop    %ebx
80105c2d:	5e                   	pop    %esi
80105c2e:	5f                   	pop    %edi
80105c2f:	5d                   	pop    %ebp
      exit();
80105c30:	e9 db e1 ff ff       	jmp    80103e10 <exit>
80105c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105c40:	e8 cb e1 ff ff       	call   80103e10 <exit>
80105c45:	e9 75 fe ff ff       	jmp    80105abf <trap+0xcf>
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c50:	e8 bb e1 ff ff       	call   80103e10 <exit>
80105c55:	eb b5                	jmp    80105c0c <trap+0x21c>
80105c57:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c60:	e8 7b dd ff ff       	call   801039e0 <cpuid>
80105c65:	89 74 24 10          	mov    %esi,0x10(%esp)
80105c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105c6d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c71:	8b 43 30             	mov    0x30(%ebx),%eax
80105c74:	c7 04 24 2c 7a 10 80 	movl   $0x80107a2c,(%esp)
80105c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c7f:	e8 fc a9 ff ff       	call   80100680 <cprintf>
      panic("trap");
80105c84:	c7 04 24 02 7a 10 80 	movl   $0x80107a02,(%esp)
80105c8b:	e8 d0 a6 ff ff       	call   80100360 <panic>

80105c90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c90:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105c95:	85 c0                	test   %eax,%eax
80105c97:	74 17                	je     80105cb0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c99:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c9e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c9f:	24 01                	and    $0x1,%al
80105ca1:	74 0d                	je     80105cb0 <uartgetc+0x20>
80105ca3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ca8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ca9:	0f b6 c0             	movzbl %al,%eax
80105cac:	c3                   	ret    
80105cad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb5:	c3                   	ret    
80105cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi

80105cc0 <uartputc.part.0>:
uartputc(int c)
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	56                   	push   %esi
80105cc4:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cc9:	53                   	push   %ebx
80105cca:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ccf:	83 ec 20             	sub    $0x20,%esp
80105cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cd5:	eb 18                	jmp    80105cef <uartputc.part.0+0x2f>
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105ce0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105ce7:	e8 14 cd ff ff       	call   80102a00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cec:	4b                   	dec    %ebx
80105ced:	74 07                	je     80105cf6 <uartputc.part.0+0x36>
80105cef:	89 f2                	mov    %esi,%edx
80105cf1:	ec                   	in     (%dx),%al
80105cf2:	24 20                	and    $0x20,%al
80105cf4:	74 ea                	je     80105ce0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cf6:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
80105cfa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cff:	ee                   	out    %al,(%dx)
}
80105d00:	83 c4 20             	add    $0x20,%esp
80105d03:	5b                   	pop    %ebx
80105d04:	5e                   	pop    %esi
80105d05:	5d                   	pop    %ebp
80105d06:	c3                   	ret    
80105d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <uartinit>:
{
80105d10:	55                   	push   %ebp
80105d11:	31 c9                	xor    %ecx,%ecx
80105d13:	89 e5                	mov    %esp,%ebp
80105d15:	88 c8                	mov    %cl,%al
80105d17:	57                   	push   %edi
80105d18:	56                   	push   %esi
80105d19:	53                   	push   %ebx
80105d1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d1f:	83 ec 2c             	sub    $0x2c,%esp
80105d22:	89 da                	mov    %ebx,%edx
80105d24:	ee                   	out    %al,(%dx)
80105d25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d2a:	b0 80                	mov    $0x80,%al
80105d2c:	89 fa                	mov    %edi,%edx
80105d2e:	ee                   	out    %al,(%dx)
80105d2f:	b0 0c                	mov    $0xc,%al
80105d31:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d36:	ee                   	out    %al,(%dx)
80105d37:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d3c:	88 c8                	mov    %cl,%al
80105d3e:	89 f2                	mov    %esi,%edx
80105d40:	ee                   	out    %al,(%dx)
80105d41:	b0 03                	mov    $0x3,%al
80105d43:	89 fa                	mov    %edi,%edx
80105d45:	ee                   	out    %al,(%dx)
80105d46:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d4b:	88 c8                	mov    %cl,%al
80105d4d:	ee                   	out    %al,(%dx)
80105d4e:	b0 01                	mov    $0x1,%al
80105d50:	89 f2                	mov    %esi,%edx
80105d52:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d53:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d58:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d59:	fe c0                	inc    %al
80105d5b:	74 65                	je     80105dc2 <uartinit+0xb2>
  uart = 1;
80105d5d:	be 01 00 00 00       	mov    $0x1,%esi
80105d62:	89 da                	mov    %ebx,%edx
80105d64:	89 35 bc a5 10 80    	mov    %esi,0x8010a5bc
80105d6a:	ec                   	in     (%dx),%al
80105d6b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d70:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d71:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105d78:	31 ff                	xor    %edi,%edi
  for(p="xv6...\n"; *p; p++)
80105d7a:	bb 24 7b 10 80       	mov    $0x80107b24,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d7f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105d83:	e8 b8 c7 ff ff       	call   80102540 <ioapicenable>
80105d88:	b2 76                	mov    $0x76,%dl
  for(p="xv6...\n"; *p; p++)
80105d8a:	b8 78 00 00 00       	mov    $0x78,%eax
80105d8f:	eb 16                	jmp    80105da7 <uartinit+0x97>
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop
80105da0:	0f be c2             	movsbl %dl,%eax
80105da3:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
  if(!uart)
80105da7:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
80105dad:	85 c9                	test   %ecx,%ecx
80105daf:	74 0c                	je     80105dbd <uartinit+0xad>
80105db1:	88 55 e7             	mov    %dl,-0x19(%ebp)
80105db4:	e8 07 ff ff ff       	call   80105cc0 <uartputc.part.0>
80105db9:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  for(p="xv6...\n"; *p; p++)
80105dbd:	43                   	inc    %ebx
80105dbe:	84 d2                	test   %dl,%dl
80105dc0:	75 de                	jne    80105da0 <uartinit+0x90>
}
80105dc2:	83 c4 2c             	add    $0x2c,%esp
80105dc5:	5b                   	pop    %ebx
80105dc6:	5e                   	pop    %esi
80105dc7:	5f                   	pop    %edi
80105dc8:	5d                   	pop    %ebp
80105dc9:	c3                   	ret    
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dd0 <uartputc>:
{
80105dd0:	55                   	push   %ebp
  if(!uart)
80105dd1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105dd7:	89 e5                	mov    %esp,%ebp
80105dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ddc:	85 d2                	test   %edx,%edx
80105dde:	74 10                	je     80105df0 <uartputc+0x20>
}
80105de0:	5d                   	pop    %ebp
80105de1:	e9 da fe ff ff       	jmp    80105cc0 <uartputc.part.0>
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
80105df0:	5d                   	pop    %ebp
80105df1:	c3                   	ret    
80105df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <uartintr>:

void
uartintr(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105e06:	c7 04 24 90 5c 10 80 	movl   $0x80105c90,(%esp)
80105e0d:	e8 1e aa ff ff       	call   80100830 <consoleintr>
}
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    

80105e14 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $0
80105e16:	6a 00                	push   $0x0
  jmp alltraps
80105e18:	e9 f8 fa ff ff       	jmp    80105915 <alltraps>

80105e1d <vector1>:
.globl vector1
vector1:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $1
80105e1f:	6a 01                	push   $0x1
  jmp alltraps
80105e21:	e9 ef fa ff ff       	jmp    80105915 <alltraps>

80105e26 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $2
80105e28:	6a 02                	push   $0x2
  jmp alltraps
80105e2a:	e9 e6 fa ff ff       	jmp    80105915 <alltraps>

80105e2f <vector3>:
.globl vector3
vector3:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $3
80105e31:	6a 03                	push   $0x3
  jmp alltraps
80105e33:	e9 dd fa ff ff       	jmp    80105915 <alltraps>

80105e38 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $4
80105e3a:	6a 04                	push   $0x4
  jmp alltraps
80105e3c:	e9 d4 fa ff ff       	jmp    80105915 <alltraps>

80105e41 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $5
80105e43:	6a 05                	push   $0x5
  jmp alltraps
80105e45:	e9 cb fa ff ff       	jmp    80105915 <alltraps>

80105e4a <vector6>:
.globl vector6
vector6:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $6
80105e4c:	6a 06                	push   $0x6
  jmp alltraps
80105e4e:	e9 c2 fa ff ff       	jmp    80105915 <alltraps>

80105e53 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $7
80105e55:	6a 07                	push   $0x7
  jmp alltraps
80105e57:	e9 b9 fa ff ff       	jmp    80105915 <alltraps>

80105e5c <vector8>:
.globl vector8
vector8:
  pushl $8
80105e5c:	6a 08                	push   $0x8
  jmp alltraps
80105e5e:	e9 b2 fa ff ff       	jmp    80105915 <alltraps>

80105e63 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $9
80105e65:	6a 09                	push   $0x9
  jmp alltraps
80105e67:	e9 a9 fa ff ff       	jmp    80105915 <alltraps>

80105e6c <vector10>:
.globl vector10
vector10:
  pushl $10
80105e6c:	6a 0a                	push   $0xa
  jmp alltraps
80105e6e:	e9 a2 fa ff ff       	jmp    80105915 <alltraps>

80105e73 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e73:	6a 0b                	push   $0xb
  jmp alltraps
80105e75:	e9 9b fa ff ff       	jmp    80105915 <alltraps>

80105e7a <vector12>:
.globl vector12
vector12:
  pushl $12
80105e7a:	6a 0c                	push   $0xc
  jmp alltraps
80105e7c:	e9 94 fa ff ff       	jmp    80105915 <alltraps>

80105e81 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e81:	6a 0d                	push   $0xd
  jmp alltraps
80105e83:	e9 8d fa ff ff       	jmp    80105915 <alltraps>

80105e88 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e88:	6a 0e                	push   $0xe
  jmp alltraps
80105e8a:	e9 86 fa ff ff       	jmp    80105915 <alltraps>

80105e8f <vector15>:
.globl vector15
vector15:
  pushl $0
80105e8f:	6a 00                	push   $0x0
  pushl $15
80105e91:	6a 0f                	push   $0xf
  jmp alltraps
80105e93:	e9 7d fa ff ff       	jmp    80105915 <alltraps>

80105e98 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e98:	6a 00                	push   $0x0
  pushl $16
80105e9a:	6a 10                	push   $0x10
  jmp alltraps
80105e9c:	e9 74 fa ff ff       	jmp    80105915 <alltraps>

80105ea1 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ea1:	6a 11                	push   $0x11
  jmp alltraps
80105ea3:	e9 6d fa ff ff       	jmp    80105915 <alltraps>

80105ea8 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $18
80105eaa:	6a 12                	push   $0x12
  jmp alltraps
80105eac:	e9 64 fa ff ff       	jmp    80105915 <alltraps>

80105eb1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $19
80105eb3:	6a 13                	push   $0x13
  jmp alltraps
80105eb5:	e9 5b fa ff ff       	jmp    80105915 <alltraps>

80105eba <vector20>:
.globl vector20
vector20:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $20
80105ebc:	6a 14                	push   $0x14
  jmp alltraps
80105ebe:	e9 52 fa ff ff       	jmp    80105915 <alltraps>

80105ec3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $21
80105ec5:	6a 15                	push   $0x15
  jmp alltraps
80105ec7:	e9 49 fa ff ff       	jmp    80105915 <alltraps>

80105ecc <vector22>:
.globl vector22
vector22:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $22
80105ece:	6a 16                	push   $0x16
  jmp alltraps
80105ed0:	e9 40 fa ff ff       	jmp    80105915 <alltraps>

80105ed5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $23
80105ed7:	6a 17                	push   $0x17
  jmp alltraps
80105ed9:	e9 37 fa ff ff       	jmp    80105915 <alltraps>

80105ede <vector24>:
.globl vector24
vector24:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $24
80105ee0:	6a 18                	push   $0x18
  jmp alltraps
80105ee2:	e9 2e fa ff ff       	jmp    80105915 <alltraps>

80105ee7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $25
80105ee9:	6a 19                	push   $0x19
  jmp alltraps
80105eeb:	e9 25 fa ff ff       	jmp    80105915 <alltraps>

80105ef0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $26
80105ef2:	6a 1a                	push   $0x1a
  jmp alltraps
80105ef4:	e9 1c fa ff ff       	jmp    80105915 <alltraps>

80105ef9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $27
80105efb:	6a 1b                	push   $0x1b
  jmp alltraps
80105efd:	e9 13 fa ff ff       	jmp    80105915 <alltraps>

80105f02 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $28
80105f04:	6a 1c                	push   $0x1c
  jmp alltraps
80105f06:	e9 0a fa ff ff       	jmp    80105915 <alltraps>

80105f0b <vector29>:
.globl vector29
vector29:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $29
80105f0d:	6a 1d                	push   $0x1d
  jmp alltraps
80105f0f:	e9 01 fa ff ff       	jmp    80105915 <alltraps>

80105f14 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $30
80105f16:	6a 1e                	push   $0x1e
  jmp alltraps
80105f18:	e9 f8 f9 ff ff       	jmp    80105915 <alltraps>

80105f1d <vector31>:
.globl vector31
vector31:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $31
80105f1f:	6a 1f                	push   $0x1f
  jmp alltraps
80105f21:	e9 ef f9 ff ff       	jmp    80105915 <alltraps>

80105f26 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $32
80105f28:	6a 20                	push   $0x20
  jmp alltraps
80105f2a:	e9 e6 f9 ff ff       	jmp    80105915 <alltraps>

80105f2f <vector33>:
.globl vector33
vector33:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $33
80105f31:	6a 21                	push   $0x21
  jmp alltraps
80105f33:	e9 dd f9 ff ff       	jmp    80105915 <alltraps>

80105f38 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $34
80105f3a:	6a 22                	push   $0x22
  jmp alltraps
80105f3c:	e9 d4 f9 ff ff       	jmp    80105915 <alltraps>

80105f41 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $35
80105f43:	6a 23                	push   $0x23
  jmp alltraps
80105f45:	e9 cb f9 ff ff       	jmp    80105915 <alltraps>

80105f4a <vector36>:
.globl vector36
vector36:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $36
80105f4c:	6a 24                	push   $0x24
  jmp alltraps
80105f4e:	e9 c2 f9 ff ff       	jmp    80105915 <alltraps>

80105f53 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $37
80105f55:	6a 25                	push   $0x25
  jmp alltraps
80105f57:	e9 b9 f9 ff ff       	jmp    80105915 <alltraps>

80105f5c <vector38>:
.globl vector38
vector38:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $38
80105f5e:	6a 26                	push   $0x26
  jmp alltraps
80105f60:	e9 b0 f9 ff ff       	jmp    80105915 <alltraps>

80105f65 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $39
80105f67:	6a 27                	push   $0x27
  jmp alltraps
80105f69:	e9 a7 f9 ff ff       	jmp    80105915 <alltraps>

80105f6e <vector40>:
.globl vector40
vector40:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $40
80105f70:	6a 28                	push   $0x28
  jmp alltraps
80105f72:	e9 9e f9 ff ff       	jmp    80105915 <alltraps>

80105f77 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $41
80105f79:	6a 29                	push   $0x29
  jmp alltraps
80105f7b:	e9 95 f9 ff ff       	jmp    80105915 <alltraps>

80105f80 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $42
80105f82:	6a 2a                	push   $0x2a
  jmp alltraps
80105f84:	e9 8c f9 ff ff       	jmp    80105915 <alltraps>

80105f89 <vector43>:
.globl vector43
vector43:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $43
80105f8b:	6a 2b                	push   $0x2b
  jmp alltraps
80105f8d:	e9 83 f9 ff ff       	jmp    80105915 <alltraps>

80105f92 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $44
80105f94:	6a 2c                	push   $0x2c
  jmp alltraps
80105f96:	e9 7a f9 ff ff       	jmp    80105915 <alltraps>

80105f9b <vector45>:
.globl vector45
vector45:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $45
80105f9d:	6a 2d                	push   $0x2d
  jmp alltraps
80105f9f:	e9 71 f9 ff ff       	jmp    80105915 <alltraps>

80105fa4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $46
80105fa6:	6a 2e                	push   $0x2e
  jmp alltraps
80105fa8:	e9 68 f9 ff ff       	jmp    80105915 <alltraps>

80105fad <vector47>:
.globl vector47
vector47:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $47
80105faf:	6a 2f                	push   $0x2f
  jmp alltraps
80105fb1:	e9 5f f9 ff ff       	jmp    80105915 <alltraps>

80105fb6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $48
80105fb8:	6a 30                	push   $0x30
  jmp alltraps
80105fba:	e9 56 f9 ff ff       	jmp    80105915 <alltraps>

80105fbf <vector49>:
.globl vector49
vector49:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $49
80105fc1:	6a 31                	push   $0x31
  jmp alltraps
80105fc3:	e9 4d f9 ff ff       	jmp    80105915 <alltraps>

80105fc8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $50
80105fca:	6a 32                	push   $0x32
  jmp alltraps
80105fcc:	e9 44 f9 ff ff       	jmp    80105915 <alltraps>

80105fd1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $51
80105fd3:	6a 33                	push   $0x33
  jmp alltraps
80105fd5:	e9 3b f9 ff ff       	jmp    80105915 <alltraps>

80105fda <vector52>:
.globl vector52
vector52:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $52
80105fdc:	6a 34                	push   $0x34
  jmp alltraps
80105fde:	e9 32 f9 ff ff       	jmp    80105915 <alltraps>

80105fe3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $53
80105fe5:	6a 35                	push   $0x35
  jmp alltraps
80105fe7:	e9 29 f9 ff ff       	jmp    80105915 <alltraps>

80105fec <vector54>:
.globl vector54
vector54:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $54
80105fee:	6a 36                	push   $0x36
  jmp alltraps
80105ff0:	e9 20 f9 ff ff       	jmp    80105915 <alltraps>

80105ff5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $55
80105ff7:	6a 37                	push   $0x37
  jmp alltraps
80105ff9:	e9 17 f9 ff ff       	jmp    80105915 <alltraps>

80105ffe <vector56>:
.globl vector56
vector56:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $56
80106000:	6a 38                	push   $0x38
  jmp alltraps
80106002:	e9 0e f9 ff ff       	jmp    80105915 <alltraps>

80106007 <vector57>:
.globl vector57
vector57:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $57
80106009:	6a 39                	push   $0x39
  jmp alltraps
8010600b:	e9 05 f9 ff ff       	jmp    80105915 <alltraps>

80106010 <vector58>:
.globl vector58
vector58:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $58
80106012:	6a 3a                	push   $0x3a
  jmp alltraps
80106014:	e9 fc f8 ff ff       	jmp    80105915 <alltraps>

80106019 <vector59>:
.globl vector59
vector59:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $59
8010601b:	6a 3b                	push   $0x3b
  jmp alltraps
8010601d:	e9 f3 f8 ff ff       	jmp    80105915 <alltraps>

80106022 <vector60>:
.globl vector60
vector60:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $60
80106024:	6a 3c                	push   $0x3c
  jmp alltraps
80106026:	e9 ea f8 ff ff       	jmp    80105915 <alltraps>

8010602b <vector61>:
.globl vector61
vector61:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $61
8010602d:	6a 3d                	push   $0x3d
  jmp alltraps
8010602f:	e9 e1 f8 ff ff       	jmp    80105915 <alltraps>

80106034 <vector62>:
.globl vector62
vector62:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $62
80106036:	6a 3e                	push   $0x3e
  jmp alltraps
80106038:	e9 d8 f8 ff ff       	jmp    80105915 <alltraps>

8010603d <vector63>:
.globl vector63
vector63:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $63
8010603f:	6a 3f                	push   $0x3f
  jmp alltraps
80106041:	e9 cf f8 ff ff       	jmp    80105915 <alltraps>

80106046 <vector64>:
.globl vector64
vector64:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $64
80106048:	6a 40                	push   $0x40
  jmp alltraps
8010604a:	e9 c6 f8 ff ff       	jmp    80105915 <alltraps>

8010604f <vector65>:
.globl vector65
vector65:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $65
80106051:	6a 41                	push   $0x41
  jmp alltraps
80106053:	e9 bd f8 ff ff       	jmp    80105915 <alltraps>

80106058 <vector66>:
.globl vector66
vector66:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $66
8010605a:	6a 42                	push   $0x42
  jmp alltraps
8010605c:	e9 b4 f8 ff ff       	jmp    80105915 <alltraps>

80106061 <vector67>:
.globl vector67
vector67:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $67
80106063:	6a 43                	push   $0x43
  jmp alltraps
80106065:	e9 ab f8 ff ff       	jmp    80105915 <alltraps>

8010606a <vector68>:
.globl vector68
vector68:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $68
8010606c:	6a 44                	push   $0x44
  jmp alltraps
8010606e:	e9 a2 f8 ff ff       	jmp    80105915 <alltraps>

80106073 <vector69>:
.globl vector69
vector69:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $69
80106075:	6a 45                	push   $0x45
  jmp alltraps
80106077:	e9 99 f8 ff ff       	jmp    80105915 <alltraps>

8010607c <vector70>:
.globl vector70
vector70:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $70
8010607e:	6a 46                	push   $0x46
  jmp alltraps
80106080:	e9 90 f8 ff ff       	jmp    80105915 <alltraps>

80106085 <vector71>:
.globl vector71
vector71:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $71
80106087:	6a 47                	push   $0x47
  jmp alltraps
80106089:	e9 87 f8 ff ff       	jmp    80105915 <alltraps>

8010608e <vector72>:
.globl vector72
vector72:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $72
80106090:	6a 48                	push   $0x48
  jmp alltraps
80106092:	e9 7e f8 ff ff       	jmp    80105915 <alltraps>

80106097 <vector73>:
.globl vector73
vector73:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $73
80106099:	6a 49                	push   $0x49
  jmp alltraps
8010609b:	e9 75 f8 ff ff       	jmp    80105915 <alltraps>

801060a0 <vector74>:
.globl vector74
vector74:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $74
801060a2:	6a 4a                	push   $0x4a
  jmp alltraps
801060a4:	e9 6c f8 ff ff       	jmp    80105915 <alltraps>

801060a9 <vector75>:
.globl vector75
vector75:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $75
801060ab:	6a 4b                	push   $0x4b
  jmp alltraps
801060ad:	e9 63 f8 ff ff       	jmp    80105915 <alltraps>

801060b2 <vector76>:
.globl vector76
vector76:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $76
801060b4:	6a 4c                	push   $0x4c
  jmp alltraps
801060b6:	e9 5a f8 ff ff       	jmp    80105915 <alltraps>

801060bb <vector77>:
.globl vector77
vector77:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $77
801060bd:	6a 4d                	push   $0x4d
  jmp alltraps
801060bf:	e9 51 f8 ff ff       	jmp    80105915 <alltraps>

801060c4 <vector78>:
.globl vector78
vector78:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $78
801060c6:	6a 4e                	push   $0x4e
  jmp alltraps
801060c8:	e9 48 f8 ff ff       	jmp    80105915 <alltraps>

801060cd <vector79>:
.globl vector79
vector79:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $79
801060cf:	6a 4f                	push   $0x4f
  jmp alltraps
801060d1:	e9 3f f8 ff ff       	jmp    80105915 <alltraps>

801060d6 <vector80>:
.globl vector80
vector80:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $80
801060d8:	6a 50                	push   $0x50
  jmp alltraps
801060da:	e9 36 f8 ff ff       	jmp    80105915 <alltraps>

801060df <vector81>:
.globl vector81
vector81:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $81
801060e1:	6a 51                	push   $0x51
  jmp alltraps
801060e3:	e9 2d f8 ff ff       	jmp    80105915 <alltraps>

801060e8 <vector82>:
.globl vector82
vector82:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $82
801060ea:	6a 52                	push   $0x52
  jmp alltraps
801060ec:	e9 24 f8 ff ff       	jmp    80105915 <alltraps>

801060f1 <vector83>:
.globl vector83
vector83:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $83
801060f3:	6a 53                	push   $0x53
  jmp alltraps
801060f5:	e9 1b f8 ff ff       	jmp    80105915 <alltraps>

801060fa <vector84>:
.globl vector84
vector84:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $84
801060fc:	6a 54                	push   $0x54
  jmp alltraps
801060fe:	e9 12 f8 ff ff       	jmp    80105915 <alltraps>

80106103 <vector85>:
.globl vector85
vector85:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $85
80106105:	6a 55                	push   $0x55
  jmp alltraps
80106107:	e9 09 f8 ff ff       	jmp    80105915 <alltraps>

8010610c <vector86>:
.globl vector86
vector86:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $86
8010610e:	6a 56                	push   $0x56
  jmp alltraps
80106110:	e9 00 f8 ff ff       	jmp    80105915 <alltraps>

80106115 <vector87>:
.globl vector87
vector87:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $87
80106117:	6a 57                	push   $0x57
  jmp alltraps
80106119:	e9 f7 f7 ff ff       	jmp    80105915 <alltraps>

8010611e <vector88>:
.globl vector88
vector88:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $88
80106120:	6a 58                	push   $0x58
  jmp alltraps
80106122:	e9 ee f7 ff ff       	jmp    80105915 <alltraps>

80106127 <vector89>:
.globl vector89
vector89:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $89
80106129:	6a 59                	push   $0x59
  jmp alltraps
8010612b:	e9 e5 f7 ff ff       	jmp    80105915 <alltraps>

80106130 <vector90>:
.globl vector90
vector90:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $90
80106132:	6a 5a                	push   $0x5a
  jmp alltraps
80106134:	e9 dc f7 ff ff       	jmp    80105915 <alltraps>

80106139 <vector91>:
.globl vector91
vector91:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $91
8010613b:	6a 5b                	push   $0x5b
  jmp alltraps
8010613d:	e9 d3 f7 ff ff       	jmp    80105915 <alltraps>

80106142 <vector92>:
.globl vector92
vector92:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $92
80106144:	6a 5c                	push   $0x5c
  jmp alltraps
80106146:	e9 ca f7 ff ff       	jmp    80105915 <alltraps>

8010614b <vector93>:
.globl vector93
vector93:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $93
8010614d:	6a 5d                	push   $0x5d
  jmp alltraps
8010614f:	e9 c1 f7 ff ff       	jmp    80105915 <alltraps>

80106154 <vector94>:
.globl vector94
vector94:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $94
80106156:	6a 5e                	push   $0x5e
  jmp alltraps
80106158:	e9 b8 f7 ff ff       	jmp    80105915 <alltraps>

8010615d <vector95>:
.globl vector95
vector95:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $95
8010615f:	6a 5f                	push   $0x5f
  jmp alltraps
80106161:	e9 af f7 ff ff       	jmp    80105915 <alltraps>

80106166 <vector96>:
.globl vector96
vector96:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $96
80106168:	6a 60                	push   $0x60
  jmp alltraps
8010616a:	e9 a6 f7 ff ff       	jmp    80105915 <alltraps>

8010616f <vector97>:
.globl vector97
vector97:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $97
80106171:	6a 61                	push   $0x61
  jmp alltraps
80106173:	e9 9d f7 ff ff       	jmp    80105915 <alltraps>

80106178 <vector98>:
.globl vector98
vector98:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $98
8010617a:	6a 62                	push   $0x62
  jmp alltraps
8010617c:	e9 94 f7 ff ff       	jmp    80105915 <alltraps>

80106181 <vector99>:
.globl vector99
vector99:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $99
80106183:	6a 63                	push   $0x63
  jmp alltraps
80106185:	e9 8b f7 ff ff       	jmp    80105915 <alltraps>

8010618a <vector100>:
.globl vector100
vector100:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $100
8010618c:	6a 64                	push   $0x64
  jmp alltraps
8010618e:	e9 82 f7 ff ff       	jmp    80105915 <alltraps>

80106193 <vector101>:
.globl vector101
vector101:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $101
80106195:	6a 65                	push   $0x65
  jmp alltraps
80106197:	e9 79 f7 ff ff       	jmp    80105915 <alltraps>

8010619c <vector102>:
.globl vector102
vector102:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $102
8010619e:	6a 66                	push   $0x66
  jmp alltraps
801061a0:	e9 70 f7 ff ff       	jmp    80105915 <alltraps>

801061a5 <vector103>:
.globl vector103
vector103:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $103
801061a7:	6a 67                	push   $0x67
  jmp alltraps
801061a9:	e9 67 f7 ff ff       	jmp    80105915 <alltraps>

801061ae <vector104>:
.globl vector104
vector104:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $104
801061b0:	6a 68                	push   $0x68
  jmp alltraps
801061b2:	e9 5e f7 ff ff       	jmp    80105915 <alltraps>

801061b7 <vector105>:
.globl vector105
vector105:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $105
801061b9:	6a 69                	push   $0x69
  jmp alltraps
801061bb:	e9 55 f7 ff ff       	jmp    80105915 <alltraps>

801061c0 <vector106>:
.globl vector106
vector106:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $106
801061c2:	6a 6a                	push   $0x6a
  jmp alltraps
801061c4:	e9 4c f7 ff ff       	jmp    80105915 <alltraps>

801061c9 <vector107>:
.globl vector107
vector107:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $107
801061cb:	6a 6b                	push   $0x6b
  jmp alltraps
801061cd:	e9 43 f7 ff ff       	jmp    80105915 <alltraps>

801061d2 <vector108>:
.globl vector108
vector108:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $108
801061d4:	6a 6c                	push   $0x6c
  jmp alltraps
801061d6:	e9 3a f7 ff ff       	jmp    80105915 <alltraps>

801061db <vector109>:
.globl vector109
vector109:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $109
801061dd:	6a 6d                	push   $0x6d
  jmp alltraps
801061df:	e9 31 f7 ff ff       	jmp    80105915 <alltraps>

801061e4 <vector110>:
.globl vector110
vector110:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $110
801061e6:	6a 6e                	push   $0x6e
  jmp alltraps
801061e8:	e9 28 f7 ff ff       	jmp    80105915 <alltraps>

801061ed <vector111>:
.globl vector111
vector111:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $111
801061ef:	6a 6f                	push   $0x6f
  jmp alltraps
801061f1:	e9 1f f7 ff ff       	jmp    80105915 <alltraps>

801061f6 <vector112>:
.globl vector112
vector112:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $112
801061f8:	6a 70                	push   $0x70
  jmp alltraps
801061fa:	e9 16 f7 ff ff       	jmp    80105915 <alltraps>

801061ff <vector113>:
.globl vector113
vector113:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $113
80106201:	6a 71                	push   $0x71
  jmp alltraps
80106203:	e9 0d f7 ff ff       	jmp    80105915 <alltraps>

80106208 <vector114>:
.globl vector114
vector114:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $114
8010620a:	6a 72                	push   $0x72
  jmp alltraps
8010620c:	e9 04 f7 ff ff       	jmp    80105915 <alltraps>

80106211 <vector115>:
.globl vector115
vector115:
  pushl $0
80106211:	6a 00                	push   $0x0
  pushl $115
80106213:	6a 73                	push   $0x73
  jmp alltraps
80106215:	e9 fb f6 ff ff       	jmp    80105915 <alltraps>

8010621a <vector116>:
.globl vector116
vector116:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $116
8010621c:	6a 74                	push   $0x74
  jmp alltraps
8010621e:	e9 f2 f6 ff ff       	jmp    80105915 <alltraps>

80106223 <vector117>:
.globl vector117
vector117:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $117
80106225:	6a 75                	push   $0x75
  jmp alltraps
80106227:	e9 e9 f6 ff ff       	jmp    80105915 <alltraps>

8010622c <vector118>:
.globl vector118
vector118:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $118
8010622e:	6a 76                	push   $0x76
  jmp alltraps
80106230:	e9 e0 f6 ff ff       	jmp    80105915 <alltraps>

80106235 <vector119>:
.globl vector119
vector119:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $119
80106237:	6a 77                	push   $0x77
  jmp alltraps
80106239:	e9 d7 f6 ff ff       	jmp    80105915 <alltraps>

8010623e <vector120>:
.globl vector120
vector120:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $120
80106240:	6a 78                	push   $0x78
  jmp alltraps
80106242:	e9 ce f6 ff ff       	jmp    80105915 <alltraps>

80106247 <vector121>:
.globl vector121
vector121:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $121
80106249:	6a 79                	push   $0x79
  jmp alltraps
8010624b:	e9 c5 f6 ff ff       	jmp    80105915 <alltraps>

80106250 <vector122>:
.globl vector122
vector122:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $122
80106252:	6a 7a                	push   $0x7a
  jmp alltraps
80106254:	e9 bc f6 ff ff       	jmp    80105915 <alltraps>

80106259 <vector123>:
.globl vector123
vector123:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $123
8010625b:	6a 7b                	push   $0x7b
  jmp alltraps
8010625d:	e9 b3 f6 ff ff       	jmp    80105915 <alltraps>

80106262 <vector124>:
.globl vector124
vector124:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $124
80106264:	6a 7c                	push   $0x7c
  jmp alltraps
80106266:	e9 aa f6 ff ff       	jmp    80105915 <alltraps>

8010626b <vector125>:
.globl vector125
vector125:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $125
8010626d:	6a 7d                	push   $0x7d
  jmp alltraps
8010626f:	e9 a1 f6 ff ff       	jmp    80105915 <alltraps>

80106274 <vector126>:
.globl vector126
vector126:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $126
80106276:	6a 7e                	push   $0x7e
  jmp alltraps
80106278:	e9 98 f6 ff ff       	jmp    80105915 <alltraps>

8010627d <vector127>:
.globl vector127
vector127:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $127
8010627f:	6a 7f                	push   $0x7f
  jmp alltraps
80106281:	e9 8f f6 ff ff       	jmp    80105915 <alltraps>

80106286 <vector128>:
.globl vector128
vector128:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $128
80106288:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010628d:	e9 83 f6 ff ff       	jmp    80105915 <alltraps>

80106292 <vector129>:
.globl vector129
vector129:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $129
80106294:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106299:	e9 77 f6 ff ff       	jmp    80105915 <alltraps>

8010629e <vector130>:
.globl vector130
vector130:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $130
801062a0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062a5:	e9 6b f6 ff ff       	jmp    80105915 <alltraps>

801062aa <vector131>:
.globl vector131
vector131:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $131
801062ac:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062b1:	e9 5f f6 ff ff       	jmp    80105915 <alltraps>

801062b6 <vector132>:
.globl vector132
vector132:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $132
801062b8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062bd:	e9 53 f6 ff ff       	jmp    80105915 <alltraps>

801062c2 <vector133>:
.globl vector133
vector133:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $133
801062c4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062c9:	e9 47 f6 ff ff       	jmp    80105915 <alltraps>

801062ce <vector134>:
.globl vector134
vector134:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $134
801062d0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062d5:	e9 3b f6 ff ff       	jmp    80105915 <alltraps>

801062da <vector135>:
.globl vector135
vector135:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $135
801062dc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062e1:	e9 2f f6 ff ff       	jmp    80105915 <alltraps>

801062e6 <vector136>:
.globl vector136
vector136:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $136
801062e8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062ed:	e9 23 f6 ff ff       	jmp    80105915 <alltraps>

801062f2 <vector137>:
.globl vector137
vector137:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $137
801062f4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062f9:	e9 17 f6 ff ff       	jmp    80105915 <alltraps>

801062fe <vector138>:
.globl vector138
vector138:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $138
80106300:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106305:	e9 0b f6 ff ff       	jmp    80105915 <alltraps>

8010630a <vector139>:
.globl vector139
vector139:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $139
8010630c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106311:	e9 ff f5 ff ff       	jmp    80105915 <alltraps>

80106316 <vector140>:
.globl vector140
vector140:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $140
80106318:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010631d:	e9 f3 f5 ff ff       	jmp    80105915 <alltraps>

80106322 <vector141>:
.globl vector141
vector141:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $141
80106324:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106329:	e9 e7 f5 ff ff       	jmp    80105915 <alltraps>

8010632e <vector142>:
.globl vector142
vector142:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $142
80106330:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106335:	e9 db f5 ff ff       	jmp    80105915 <alltraps>

8010633a <vector143>:
.globl vector143
vector143:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $143
8010633c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106341:	e9 cf f5 ff ff       	jmp    80105915 <alltraps>

80106346 <vector144>:
.globl vector144
vector144:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $144
80106348:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010634d:	e9 c3 f5 ff ff       	jmp    80105915 <alltraps>

80106352 <vector145>:
.globl vector145
vector145:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $145
80106354:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106359:	e9 b7 f5 ff ff       	jmp    80105915 <alltraps>

8010635e <vector146>:
.globl vector146
vector146:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $146
80106360:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106365:	e9 ab f5 ff ff       	jmp    80105915 <alltraps>

8010636a <vector147>:
.globl vector147
vector147:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $147
8010636c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106371:	e9 9f f5 ff ff       	jmp    80105915 <alltraps>

80106376 <vector148>:
.globl vector148
vector148:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $148
80106378:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010637d:	e9 93 f5 ff ff       	jmp    80105915 <alltraps>

80106382 <vector149>:
.globl vector149
vector149:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $149
80106384:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106389:	e9 87 f5 ff ff       	jmp    80105915 <alltraps>

8010638e <vector150>:
.globl vector150
vector150:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $150
80106390:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106395:	e9 7b f5 ff ff       	jmp    80105915 <alltraps>

8010639a <vector151>:
.globl vector151
vector151:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $151
8010639c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063a1:	e9 6f f5 ff ff       	jmp    80105915 <alltraps>

801063a6 <vector152>:
.globl vector152
vector152:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $152
801063a8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063ad:	e9 63 f5 ff ff       	jmp    80105915 <alltraps>

801063b2 <vector153>:
.globl vector153
vector153:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $153
801063b4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063b9:	e9 57 f5 ff ff       	jmp    80105915 <alltraps>

801063be <vector154>:
.globl vector154
vector154:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $154
801063c0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063c5:	e9 4b f5 ff ff       	jmp    80105915 <alltraps>

801063ca <vector155>:
.globl vector155
vector155:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $155
801063cc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063d1:	e9 3f f5 ff ff       	jmp    80105915 <alltraps>

801063d6 <vector156>:
.globl vector156
vector156:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $156
801063d8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063dd:	e9 33 f5 ff ff       	jmp    80105915 <alltraps>

801063e2 <vector157>:
.globl vector157
vector157:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $157
801063e4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063e9:	e9 27 f5 ff ff       	jmp    80105915 <alltraps>

801063ee <vector158>:
.globl vector158
vector158:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $158
801063f0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063f5:	e9 1b f5 ff ff       	jmp    80105915 <alltraps>

801063fa <vector159>:
.globl vector159
vector159:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $159
801063fc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106401:	e9 0f f5 ff ff       	jmp    80105915 <alltraps>

80106406 <vector160>:
.globl vector160
vector160:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $160
80106408:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010640d:	e9 03 f5 ff ff       	jmp    80105915 <alltraps>

80106412 <vector161>:
.globl vector161
vector161:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $161
80106414:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106419:	e9 f7 f4 ff ff       	jmp    80105915 <alltraps>

8010641e <vector162>:
.globl vector162
vector162:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $162
80106420:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106425:	e9 eb f4 ff ff       	jmp    80105915 <alltraps>

8010642a <vector163>:
.globl vector163
vector163:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $163
8010642c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106431:	e9 df f4 ff ff       	jmp    80105915 <alltraps>

80106436 <vector164>:
.globl vector164
vector164:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $164
80106438:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010643d:	e9 d3 f4 ff ff       	jmp    80105915 <alltraps>

80106442 <vector165>:
.globl vector165
vector165:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $165
80106444:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106449:	e9 c7 f4 ff ff       	jmp    80105915 <alltraps>

8010644e <vector166>:
.globl vector166
vector166:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $166
80106450:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106455:	e9 bb f4 ff ff       	jmp    80105915 <alltraps>

8010645a <vector167>:
.globl vector167
vector167:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $167
8010645c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106461:	e9 af f4 ff ff       	jmp    80105915 <alltraps>

80106466 <vector168>:
.globl vector168
vector168:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $168
80106468:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010646d:	e9 a3 f4 ff ff       	jmp    80105915 <alltraps>

80106472 <vector169>:
.globl vector169
vector169:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $169
80106474:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106479:	e9 97 f4 ff ff       	jmp    80105915 <alltraps>

8010647e <vector170>:
.globl vector170
vector170:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $170
80106480:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106485:	e9 8b f4 ff ff       	jmp    80105915 <alltraps>

8010648a <vector171>:
.globl vector171
vector171:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $171
8010648c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106491:	e9 7f f4 ff ff       	jmp    80105915 <alltraps>

80106496 <vector172>:
.globl vector172
vector172:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $172
80106498:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010649d:	e9 73 f4 ff ff       	jmp    80105915 <alltraps>

801064a2 <vector173>:
.globl vector173
vector173:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $173
801064a4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064a9:	e9 67 f4 ff ff       	jmp    80105915 <alltraps>

801064ae <vector174>:
.globl vector174
vector174:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $174
801064b0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064b5:	e9 5b f4 ff ff       	jmp    80105915 <alltraps>

801064ba <vector175>:
.globl vector175
vector175:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $175
801064bc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064c1:	e9 4f f4 ff ff       	jmp    80105915 <alltraps>

801064c6 <vector176>:
.globl vector176
vector176:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $176
801064c8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064cd:	e9 43 f4 ff ff       	jmp    80105915 <alltraps>

801064d2 <vector177>:
.globl vector177
vector177:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $177
801064d4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064d9:	e9 37 f4 ff ff       	jmp    80105915 <alltraps>

801064de <vector178>:
.globl vector178
vector178:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $178
801064e0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064e5:	e9 2b f4 ff ff       	jmp    80105915 <alltraps>

801064ea <vector179>:
.globl vector179
vector179:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $179
801064ec:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064f1:	e9 1f f4 ff ff       	jmp    80105915 <alltraps>

801064f6 <vector180>:
.globl vector180
vector180:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $180
801064f8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064fd:	e9 13 f4 ff ff       	jmp    80105915 <alltraps>

80106502 <vector181>:
.globl vector181
vector181:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $181
80106504:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106509:	e9 07 f4 ff ff       	jmp    80105915 <alltraps>

8010650e <vector182>:
.globl vector182
vector182:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $182
80106510:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106515:	e9 fb f3 ff ff       	jmp    80105915 <alltraps>

8010651a <vector183>:
.globl vector183
vector183:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $183
8010651c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106521:	e9 ef f3 ff ff       	jmp    80105915 <alltraps>

80106526 <vector184>:
.globl vector184
vector184:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $184
80106528:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010652d:	e9 e3 f3 ff ff       	jmp    80105915 <alltraps>

80106532 <vector185>:
.globl vector185
vector185:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $185
80106534:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106539:	e9 d7 f3 ff ff       	jmp    80105915 <alltraps>

8010653e <vector186>:
.globl vector186
vector186:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $186
80106540:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106545:	e9 cb f3 ff ff       	jmp    80105915 <alltraps>

8010654a <vector187>:
.globl vector187
vector187:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $187
8010654c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106551:	e9 bf f3 ff ff       	jmp    80105915 <alltraps>

80106556 <vector188>:
.globl vector188
vector188:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $188
80106558:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010655d:	e9 b3 f3 ff ff       	jmp    80105915 <alltraps>

80106562 <vector189>:
.globl vector189
vector189:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $189
80106564:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106569:	e9 a7 f3 ff ff       	jmp    80105915 <alltraps>

8010656e <vector190>:
.globl vector190
vector190:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $190
80106570:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106575:	e9 9b f3 ff ff       	jmp    80105915 <alltraps>

8010657a <vector191>:
.globl vector191
vector191:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $191
8010657c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106581:	e9 8f f3 ff ff       	jmp    80105915 <alltraps>

80106586 <vector192>:
.globl vector192
vector192:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $192
80106588:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010658d:	e9 83 f3 ff ff       	jmp    80105915 <alltraps>

80106592 <vector193>:
.globl vector193
vector193:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $193
80106594:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106599:	e9 77 f3 ff ff       	jmp    80105915 <alltraps>

8010659e <vector194>:
.globl vector194
vector194:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $194
801065a0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065a5:	e9 6b f3 ff ff       	jmp    80105915 <alltraps>

801065aa <vector195>:
.globl vector195
vector195:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $195
801065ac:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065b1:	e9 5f f3 ff ff       	jmp    80105915 <alltraps>

801065b6 <vector196>:
.globl vector196
vector196:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $196
801065b8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065bd:	e9 53 f3 ff ff       	jmp    80105915 <alltraps>

801065c2 <vector197>:
.globl vector197
vector197:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $197
801065c4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065c9:	e9 47 f3 ff ff       	jmp    80105915 <alltraps>

801065ce <vector198>:
.globl vector198
vector198:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $198
801065d0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065d5:	e9 3b f3 ff ff       	jmp    80105915 <alltraps>

801065da <vector199>:
.globl vector199
vector199:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $199
801065dc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065e1:	e9 2f f3 ff ff       	jmp    80105915 <alltraps>

801065e6 <vector200>:
.globl vector200
vector200:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $200
801065e8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065ed:	e9 23 f3 ff ff       	jmp    80105915 <alltraps>

801065f2 <vector201>:
.globl vector201
vector201:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $201
801065f4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065f9:	e9 17 f3 ff ff       	jmp    80105915 <alltraps>

801065fe <vector202>:
.globl vector202
vector202:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $202
80106600:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106605:	e9 0b f3 ff ff       	jmp    80105915 <alltraps>

8010660a <vector203>:
.globl vector203
vector203:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $203
8010660c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106611:	e9 ff f2 ff ff       	jmp    80105915 <alltraps>

80106616 <vector204>:
.globl vector204
vector204:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $204
80106618:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010661d:	e9 f3 f2 ff ff       	jmp    80105915 <alltraps>

80106622 <vector205>:
.globl vector205
vector205:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $205
80106624:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106629:	e9 e7 f2 ff ff       	jmp    80105915 <alltraps>

8010662e <vector206>:
.globl vector206
vector206:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $206
80106630:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106635:	e9 db f2 ff ff       	jmp    80105915 <alltraps>

8010663a <vector207>:
.globl vector207
vector207:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $207
8010663c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106641:	e9 cf f2 ff ff       	jmp    80105915 <alltraps>

80106646 <vector208>:
.globl vector208
vector208:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $208
80106648:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010664d:	e9 c3 f2 ff ff       	jmp    80105915 <alltraps>

80106652 <vector209>:
.globl vector209
vector209:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $209
80106654:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106659:	e9 b7 f2 ff ff       	jmp    80105915 <alltraps>

8010665e <vector210>:
.globl vector210
vector210:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $210
80106660:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106665:	e9 ab f2 ff ff       	jmp    80105915 <alltraps>

8010666a <vector211>:
.globl vector211
vector211:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $211
8010666c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106671:	e9 9f f2 ff ff       	jmp    80105915 <alltraps>

80106676 <vector212>:
.globl vector212
vector212:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $212
80106678:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010667d:	e9 93 f2 ff ff       	jmp    80105915 <alltraps>

80106682 <vector213>:
.globl vector213
vector213:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $213
80106684:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106689:	e9 87 f2 ff ff       	jmp    80105915 <alltraps>

8010668e <vector214>:
.globl vector214
vector214:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $214
80106690:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106695:	e9 7b f2 ff ff       	jmp    80105915 <alltraps>

8010669a <vector215>:
.globl vector215
vector215:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $215
8010669c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066a1:	e9 6f f2 ff ff       	jmp    80105915 <alltraps>

801066a6 <vector216>:
.globl vector216
vector216:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $216
801066a8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066ad:	e9 63 f2 ff ff       	jmp    80105915 <alltraps>

801066b2 <vector217>:
.globl vector217
vector217:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $217
801066b4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066b9:	e9 57 f2 ff ff       	jmp    80105915 <alltraps>

801066be <vector218>:
.globl vector218
vector218:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $218
801066c0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066c5:	e9 4b f2 ff ff       	jmp    80105915 <alltraps>

801066ca <vector219>:
.globl vector219
vector219:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $219
801066cc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066d1:	e9 3f f2 ff ff       	jmp    80105915 <alltraps>

801066d6 <vector220>:
.globl vector220
vector220:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $220
801066d8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066dd:	e9 33 f2 ff ff       	jmp    80105915 <alltraps>

801066e2 <vector221>:
.globl vector221
vector221:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $221
801066e4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066e9:	e9 27 f2 ff ff       	jmp    80105915 <alltraps>

801066ee <vector222>:
.globl vector222
vector222:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $222
801066f0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066f5:	e9 1b f2 ff ff       	jmp    80105915 <alltraps>

801066fa <vector223>:
.globl vector223
vector223:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $223
801066fc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106701:	e9 0f f2 ff ff       	jmp    80105915 <alltraps>

80106706 <vector224>:
.globl vector224
vector224:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $224
80106708:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010670d:	e9 03 f2 ff ff       	jmp    80105915 <alltraps>

80106712 <vector225>:
.globl vector225
vector225:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $225
80106714:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106719:	e9 f7 f1 ff ff       	jmp    80105915 <alltraps>

8010671e <vector226>:
.globl vector226
vector226:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $226
80106720:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106725:	e9 eb f1 ff ff       	jmp    80105915 <alltraps>

8010672a <vector227>:
.globl vector227
vector227:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $227
8010672c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106731:	e9 df f1 ff ff       	jmp    80105915 <alltraps>

80106736 <vector228>:
.globl vector228
vector228:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $228
80106738:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010673d:	e9 d3 f1 ff ff       	jmp    80105915 <alltraps>

80106742 <vector229>:
.globl vector229
vector229:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $229
80106744:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106749:	e9 c7 f1 ff ff       	jmp    80105915 <alltraps>

8010674e <vector230>:
.globl vector230
vector230:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $230
80106750:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106755:	e9 bb f1 ff ff       	jmp    80105915 <alltraps>

8010675a <vector231>:
.globl vector231
vector231:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $231
8010675c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106761:	e9 af f1 ff ff       	jmp    80105915 <alltraps>

80106766 <vector232>:
.globl vector232
vector232:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $232
80106768:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010676d:	e9 a3 f1 ff ff       	jmp    80105915 <alltraps>

80106772 <vector233>:
.globl vector233
vector233:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $233
80106774:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106779:	e9 97 f1 ff ff       	jmp    80105915 <alltraps>

8010677e <vector234>:
.globl vector234
vector234:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $234
80106780:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106785:	e9 8b f1 ff ff       	jmp    80105915 <alltraps>

8010678a <vector235>:
.globl vector235
vector235:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $235
8010678c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106791:	e9 7f f1 ff ff       	jmp    80105915 <alltraps>

80106796 <vector236>:
.globl vector236
vector236:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $236
80106798:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010679d:	e9 73 f1 ff ff       	jmp    80105915 <alltraps>

801067a2 <vector237>:
.globl vector237
vector237:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $237
801067a4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067a9:	e9 67 f1 ff ff       	jmp    80105915 <alltraps>

801067ae <vector238>:
.globl vector238
vector238:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $238
801067b0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067b5:	e9 5b f1 ff ff       	jmp    80105915 <alltraps>

801067ba <vector239>:
.globl vector239
vector239:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $239
801067bc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067c1:	e9 4f f1 ff ff       	jmp    80105915 <alltraps>

801067c6 <vector240>:
.globl vector240
vector240:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $240
801067c8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067cd:	e9 43 f1 ff ff       	jmp    80105915 <alltraps>

801067d2 <vector241>:
.globl vector241
vector241:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $241
801067d4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067d9:	e9 37 f1 ff ff       	jmp    80105915 <alltraps>

801067de <vector242>:
.globl vector242
vector242:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $242
801067e0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067e5:	e9 2b f1 ff ff       	jmp    80105915 <alltraps>

801067ea <vector243>:
.globl vector243
vector243:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $243
801067ec:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067f1:	e9 1f f1 ff ff       	jmp    80105915 <alltraps>

801067f6 <vector244>:
.globl vector244
vector244:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $244
801067f8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067fd:	e9 13 f1 ff ff       	jmp    80105915 <alltraps>

80106802 <vector245>:
.globl vector245
vector245:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $245
80106804:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106809:	e9 07 f1 ff ff       	jmp    80105915 <alltraps>

8010680e <vector246>:
.globl vector246
vector246:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $246
80106810:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106815:	e9 fb f0 ff ff       	jmp    80105915 <alltraps>

8010681a <vector247>:
.globl vector247
vector247:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $247
8010681c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106821:	e9 ef f0 ff ff       	jmp    80105915 <alltraps>

80106826 <vector248>:
.globl vector248
vector248:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $248
80106828:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010682d:	e9 e3 f0 ff ff       	jmp    80105915 <alltraps>

80106832 <vector249>:
.globl vector249
vector249:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $249
80106834:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106839:	e9 d7 f0 ff ff       	jmp    80105915 <alltraps>

8010683e <vector250>:
.globl vector250
vector250:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $250
80106840:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106845:	e9 cb f0 ff ff       	jmp    80105915 <alltraps>

8010684a <vector251>:
.globl vector251
vector251:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $251
8010684c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106851:	e9 bf f0 ff ff       	jmp    80105915 <alltraps>

80106856 <vector252>:
.globl vector252
vector252:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $252
80106858:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010685d:	e9 b3 f0 ff ff       	jmp    80105915 <alltraps>

80106862 <vector253>:
.globl vector253
vector253:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $253
80106864:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106869:	e9 a7 f0 ff ff       	jmp    80105915 <alltraps>

8010686e <vector254>:
.globl vector254
vector254:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $254
80106870:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106875:	e9 9b f0 ff ff       	jmp    80105915 <alltraps>

8010687a <vector255>:
.globl vector255
vector255:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $255
8010687c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106881:	e9 8f f0 ff ff       	jmp    80105915 <alltraps>
80106886:	66 90                	xchg   %ax,%ax
80106888:	66 90                	xchg   %ax,%ax
8010688a:	66 90                	xchg   %ax,%ax
8010688c:	66 90                	xchg   %ax,%ax
8010688e:	66 90                	xchg   %ax,%ax

80106890 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 28             	sub    $0x28,%esp
80106896:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106899:	89 d6                	mov    %edx,%esi
8010689b:	89 7d fc             	mov    %edi,-0x4(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010689e:	c1 ea 16             	shr    $0x16,%edx
{
801068a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  pde = &pgdir[PDX(va)];
801068a4:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801068a7:	8b 1f                	mov    (%edi),%ebx
801068a9:	f6 c3 01             	test   $0x1,%bl
801068ac:	74 32                	je     801068e0 <walkpgdir+0x50>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801068b4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068ba:	89 f0                	mov    %esi,%eax
}
801068bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  return &pgtab[PTX(va)];
801068bf:	c1 e8 0a             	shr    $0xa,%eax
}
801068c2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  return &pgtab[PTX(va)];
801068c5:	25 fc 0f 00 00       	and    $0xffc,%eax
801068ca:	01 d8                	add    %ebx,%eax
}
801068cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801068cf:	89 ec                	mov    %ebp,%esp
801068d1:	5d                   	pop    %ebp
801068d2:	c3                   	ret    
801068d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801068e0:	85 c9                	test   %ecx,%ecx
801068e2:	74 3c                	je     80106920 <walkpgdir+0x90>
801068e4:	e8 57 be ff ff       	call   80102740 <kalloc>
801068e9:	85 c0                	test   %eax,%eax
801068eb:	89 c3                	mov    %eax,%ebx
801068ed:	74 31                	je     80106920 <walkpgdir+0x90>
    memset(pgtab, 0, PGSIZE);
801068ef:	89 1c 24             	mov    %ebx,(%esp)
801068f2:	b8 00 10 00 00       	mov    $0x1000,%eax
801068f7:	31 d2                	xor    %edx,%edx
801068f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801068fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80106901:	e8 9a de ff ff       	call   801047a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106906:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010690c:	83 c8 07             	or     $0x7,%eax
8010690f:	89 07                	mov    %eax,(%edi)
80106911:	eb a7                	jmp    801068ba <walkpgdir+0x2a>
80106913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106920:	8b 5d f4             	mov    -0xc(%ebp),%ebx
      return 0;
80106923:	31 c0                	xor    %eax,%eax
}
80106925:	8b 75 f8             	mov    -0x8(%ebp),%esi
80106928:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010692b:	89 ec                	mov    %ebp,%esp
8010692d:	5d                   	pop    %ebp
8010692e:	c3                   	ret    
8010692f:	90                   	nop

80106930 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	89 c7                	mov    %eax,%edi
80106936:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106937:	89 d6                	mov    %edx,%esi
{
80106939:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
8010693a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106940:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106944:	83 ec 2c             	sub    $0x2c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106947:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010694c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010694f:	8b 45 08             	mov    0x8(%ebp),%eax
80106952:	29 f0                	sub    %esi,%eax
80106954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106957:	eb 21                	jmp    8010697a <mappages+0x4a>
80106959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106960:	f6 00 01             	testb  $0x1,(%eax)
80106963:	75 45                	jne    801069aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106965:	8b 55 0c             	mov    0xc(%ebp),%edx
80106968:	09 d3                	or     %edx,%ebx
8010696a:	83 cb 01             	or     $0x1,%ebx
    if(a == last)
8010696d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
    *pte = pa | perm | PTE_P;
80106970:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106972:	74 2c                	je     801069a0 <mappages+0x70>
      break;
    a += PGSIZE;
80106974:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
8010697a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010697d:	b9 01 00 00 00       	mov    $0x1,%ecx
80106982:	89 f2                	mov    %esi,%edx
80106984:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106987:	89 f8                	mov    %edi,%eax
80106989:	e8 02 ff ff ff       	call   80106890 <walkpgdir>
8010698e:	85 c0                	test   %eax,%eax
80106990:	75 ce                	jne    80106960 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106992:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80106995:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010699a:	5b                   	pop    %ebx
8010699b:	5e                   	pop    %esi
8010699c:	5f                   	pop    %edi
8010699d:	5d                   	pop    %ebp
8010699e:	c3                   	ret    
8010699f:	90                   	nop
801069a0:	83 c4 2c             	add    $0x2c,%esp
  return 0;
801069a3:	31 c0                	xor    %eax,%eax
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
      panic("remap");
801069aa:	c7 04 24 2c 7b 10 80 	movl   $0x80107b2c,(%esp)
801069b1:	e8 aa 99 ff ff       	call   80100360 <panic>
801069b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069bd:	8d 76 00             	lea    0x0(%esi),%esi

801069c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	89 c6                	mov    %eax,%esi
801069c7:	53                   	push   %ebx
801069c8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069ca:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069d0:	83 ec 2c             	sub    $0x2c,%esp
801069d3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  a = PGROUNDUP(newsz);
801069d6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; a  < oldsz; a += PGSIZE){
801069dc:	39 da                	cmp    %ebx,%edx
801069de:	73 5f                	jae    80106a3f <deallocuvm.part.0+0x7f>
801069e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801069e3:	89 d7                	mov    %edx,%edi
801069e5:	eb 34                	jmp    80106a1b <deallocuvm.part.0+0x5b>
801069e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ee:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801069f0:	8b 00                	mov    (%eax),%eax
801069f2:	a8 01                	test   $0x1,%al
801069f4:	74 1a                	je     80106a10 <deallocuvm.part.0+0x50>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801069f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069fb:	74 4d                	je     80106a4a <deallocuvm.part.0+0x8a>
        panic("kfree");
      char *v = P2V(pa);
801069fd:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106a02:	89 04 24             	mov    %eax,(%esp)
80106a05:	e8 76 bb ff ff       	call   80102580 <kfree>
      *pte = 0;
80106a0a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106a10:	81 c7 00 10 00 00    	add    $0x1000,%edi
  for(; a  < oldsz; a += PGSIZE){
80106a16:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106a19:	76 24                	jbe    80106a3f <deallocuvm.part.0+0x7f>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a1b:	31 c9                	xor    %ecx,%ecx
80106a1d:	89 fa                	mov    %edi,%edx
80106a1f:	89 f0                	mov    %esi,%eax
80106a21:	e8 6a fe ff ff       	call   80106890 <walkpgdir>
    if(!pte)
80106a26:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a28:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106a2a:	75 c4                	jne    801069f0 <deallocuvm.part.0+0x30>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a2c:	89 fa                	mov    %edi,%edx
80106a2e:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106a34:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
  for(; a  < oldsz; a += PGSIZE){
80106a3a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106a3d:	77 dc                	ja     80106a1b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a42:	83 c4 2c             	add    $0x2c,%esp
80106a45:	5b                   	pop    %ebx
80106a46:	5e                   	pop    %esi
80106a47:	5f                   	pop    %edi
80106a48:	5d                   	pop    %ebp
80106a49:	c3                   	ret    
        panic("kfree");
80106a4a:	c7 04 24 86 74 10 80 	movl   $0x80107486,(%esp)
80106a51:	e8 0a 99 ff ff       	call   80100360 <panic>
80106a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a5d:	8d 76 00             	lea    0x0(%esi),%esi

80106a60 <seginit>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a66:	e8 75 cf ff ff       	call   801039e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a6b:	b9 00 9a cf 00       	mov    $0xcf9a00,%ecx
  pd[0] = size-1;
80106a70:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
80106a76:	8d 14 80             	lea    (%eax,%eax,4),%edx
80106a79:	8d 04 50             	lea    (%eax,%edx,2),%eax
80106a7c:	ba ff ff 00 00       	mov    $0xffff,%edx
80106a81:	c1 e0 04             	shl    $0x4,%eax
80106a84:	89 90 f8 27 11 80    	mov    %edx,-0x7feed808(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a8a:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a8f:	89 88 fc 27 11 80    	mov    %ecx,-0x7feed804(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a95:	b9 00 92 cf 00       	mov    $0xcf9200,%ecx
80106a9a:	89 90 00 28 11 80    	mov    %edx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aa0:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106aa5:	89 88 04 28 11 80    	mov    %ecx,-0x7feed7fc(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aab:	b9 00 fa cf 00       	mov    $0xcffa00,%ecx
80106ab0:	89 90 08 28 11 80    	mov    %edx,-0x7feed7f8(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ab6:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106abb:	89 88 0c 28 11 80    	mov    %ecx,-0x7feed7f4(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ac1:	b9 00 f2 cf 00       	mov    $0xcff200,%ecx
80106ac6:	89 90 10 28 11 80    	mov    %edx,-0x7feed7f0(%eax)
80106acc:	89 88 14 28 11 80    	mov    %ecx,-0x7feed7ec(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106ad2:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106ad7:	0f b7 d0             	movzwl %ax,%edx
80106ada:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ade:	c1 e8 10             	shr    $0x10,%eax
80106ae1:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106ae5:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ae8:	0f 01 10             	lgdtl  (%eax)
}
80106aeb:	c9                   	leave  
80106aec:	c3                   	ret    
80106aed:	8d 76 00             	lea    0x0(%esi),%esi

80106af0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106af0:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106af5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106afa:	0f 22 d8             	mov    %eax,%cr3
}
80106afd:	c3                   	ret    
80106afe:	66 90                	xchg   %ax,%ax

80106b00 <switchuvm>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 2c             	sub    $0x2c,%esp
80106b09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b0c:	85 f6                	test   %esi,%esi
80106b0e:	0f 84 c5 00 00 00    	je     80106bd9 <switchuvm+0xd9>
  if(p->kstack == 0)
80106b14:	8b 7e 08             	mov    0x8(%esi),%edi
80106b17:	85 ff                	test   %edi,%edi
80106b19:	0f 84 d2 00 00 00    	je     80106bf1 <switchuvm+0xf1>
  if(p->pgdir == 0)
80106b1f:	8b 5e 04             	mov    0x4(%esi),%ebx
80106b22:	85 db                	test   %ebx,%ebx
80106b24:	0f 84 bb 00 00 00    	je     80106be5 <switchuvm+0xe5>
  pushcli();
80106b2a:	e8 71 da ff ff       	call   801045a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b2f:	e8 3c ce ff ff       	call   80103970 <mycpu>
80106b34:	89 c3                	mov    %eax,%ebx
80106b36:	e8 35 ce ff ff       	call   80103970 <mycpu>
80106b3b:	89 c7                	mov    %eax,%edi
80106b3d:	e8 2e ce ff ff       	call   80103970 <mycpu>
80106b42:	83 c7 08             	add    $0x8,%edi
80106b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b48:	e8 23 ce ff ff       	call   80103970 <mycpu>
80106b4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b50:	ba 67 00 00 00       	mov    $0x67,%edx
80106b55:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106b5c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b63:	83 c1 08             	add    $0x8,%ecx
80106b66:	c1 e9 10             	shr    $0x10,%ecx
80106b69:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b6f:	83 c0 08             	add    $0x8,%eax
80106b72:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b77:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
80106b7e:	c1 e8 18             	shr    $0x18,%eax
80106b81:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
80106b87:	e8 e4 cd ff ff       	call   80103970 <mycpu>
80106b8c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b93:	e8 d8 cd ff ff       	call   80103970 <mycpu>
80106b98:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b9e:	8b 5e 08             	mov    0x8(%esi),%ebx
80106ba1:	e8 ca cd ff ff       	call   80103970 <mycpu>
80106ba6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bac:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106baf:	e8 bc cd ff ff       	call   80103970 <mycpu>
80106bb4:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bba:	b8 28 00 00 00       	mov    $0x28,%eax
80106bbf:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bc2:	8b 46 04             	mov    0x4(%esi),%eax
80106bc5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bca:	0f 22 d8             	mov    %eax,%cr3
}
80106bcd:	83 c4 2c             	add    $0x2c,%esp
80106bd0:	5b                   	pop    %ebx
80106bd1:	5e                   	pop    %esi
80106bd2:	5f                   	pop    %edi
80106bd3:	5d                   	pop    %ebp
  popcli();
80106bd4:	e9 17 da ff ff       	jmp    801045f0 <popcli>
    panic("switchuvm: no process");
80106bd9:	c7 04 24 32 7b 10 80 	movl   $0x80107b32,(%esp)
80106be0:	e8 7b 97 ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
80106be5:	c7 04 24 5d 7b 10 80 	movl   $0x80107b5d,(%esp)
80106bec:	e8 6f 97 ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106bf1:	c7 04 24 48 7b 10 80 	movl   $0x80107b48,(%esp)
80106bf8:	e8 63 97 ff ff       	call   80100360 <panic>
80106bfd:	8d 76 00             	lea    0x0(%esi),%esi

80106c00 <inituvm>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	83 ec 38             	sub    $0x38,%esp
80106c06:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106c09:	8b 75 10             	mov    0x10(%ebp),%esi
80106c0c:	89 7d fc             	mov    %edi,-0x4(%ebp)
80106c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c12:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80106c15:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(sz >= PGSIZE)
80106c18:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106c1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c21:	77 5b                	ja     80106c7e <inituvm+0x7e>
  mem = kalloc();
80106c23:	e8 18 bb ff ff       	call   80102740 <kalloc>
  memset(mem, 0, PGSIZE);
80106c28:	31 d2                	xor    %edx,%edx
80106c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  mem = kalloc();
80106c2e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c30:	b8 00 10 00 00       	mov    $0x1000,%eax
80106c35:	89 1c 24             	mov    %ebx,(%esp)
80106c38:	89 44 24 08          	mov    %eax,0x8(%esp)
80106c3c:	e8 5f db ff ff       	call   801047a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c41:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c47:	b9 06 00 00 00       	mov    $0x6,%ecx
80106c4c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106c50:	31 d2                	xor    %edx,%edx
80106c52:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c57:	89 04 24             	mov    %eax,(%esp)
80106c5a:	89 f8                	mov    %edi,%eax
80106c5c:	e8 cf fc ff ff       	call   80106930 <mappages>
  memmove(mem, init, sz);
80106c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c64:	89 75 10             	mov    %esi,0x10(%ebp)
}
80106c67:	8b 7d fc             	mov    -0x4(%ebp),%edi
  memmove(mem, init, sz);
80106c6a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c6d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80106c70:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  memmove(mem, init, sz);
80106c73:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106c76:	89 ec                	mov    %ebp,%esp
80106c78:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c79:	e9 e2 db ff ff       	jmp    80104860 <memmove>
    panic("inituvm: more than a page");
80106c7e:	c7 04 24 71 7b 10 80 	movl   $0x80107b71,(%esp)
80106c85:	e8 d6 96 ff ff       	call   80100360 <panic>
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c90 <loaduvm>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 2c             	sub    $0x2c,%esp
80106c99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c9c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c9f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ca4:	0f 85 9c 00 00 00    	jne    80106d46 <loaduvm+0xb6>
  for(i = 0; i < sz; i += PGSIZE){
80106caa:	01 f0                	add    %esi,%eax
80106cac:	89 f3                	mov    %esi,%ebx
80106cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cb1:	8b 45 14             	mov    0x14(%ebp),%eax
80106cb4:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106cb6:	85 f6                	test   %esi,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106cbb:	75 11                	jne    80106cce <loaduvm+0x3e>
80106cbd:	eb 71                	jmp    80106d30 <loaduvm+0xa0>
80106cbf:	90                   	nop
80106cc0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106cc6:	89 f0                	mov    %esi,%eax
80106cc8:	29 d8                	sub    %ebx,%eax
80106cca:	39 c6                	cmp    %eax,%esi
80106ccc:	76 62                	jbe    80106d30 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106cd1:	31 c9                	xor    %ecx,%ecx
80106cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd6:	29 da                	sub    %ebx,%edx
80106cd8:	e8 b3 fb ff ff       	call   80106890 <walkpgdir>
80106cdd:	85 c0                	test   %eax,%eax
80106cdf:	74 59                	je     80106d3a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106ce1:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
80106ce3:	bf 00 10 00 00       	mov    $0x1000,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ce8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106ceb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cf0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106cf6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cf9:	05 00 00 00 80       	add    $0x80000000,%eax
80106cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d02:	8b 45 10             	mov    0x10(%ebp),%eax
80106d05:	29 d9                	sub    %ebx,%ecx
80106d07:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106d0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106d0f:	89 04 24             	mov    %eax,(%esp)
80106d12:	e8 d9 ad ff ff       	call   80101af0 <readi>
80106d17:	39 f8                	cmp    %edi,%eax
80106d19:	74 a5                	je     80106cc0 <loaduvm+0x30>
}
80106d1b:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80106d1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d23:	5b                   	pop    %ebx
80106d24:	5e                   	pop    %esi
80106d25:	5f                   	pop    %edi
80106d26:	5d                   	pop    %ebp
80106d27:	c3                   	ret    
80106d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2f:	90                   	nop
80106d30:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80106d33:	31 c0                	xor    %eax,%eax
}
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106d3a:	c7 04 24 8b 7b 10 80 	movl   $0x80107b8b,(%esp)
80106d41:	e8 1a 96 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106d46:	c7 04 24 2c 7c 10 80 	movl   $0x80107c2c,(%esp)
80106d4d:	e8 0e 96 ff ff       	call   80100360 <panic>
80106d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d60 <allocuvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 2c             	sub    $0x2c,%esp
  if(newsz >= KERNBASE)
80106d69:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106d6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106d6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d72:	85 c0                	test   %eax,%eax
80106d74:	0f 88 c6 00 00 00    	js     80106e40 <allocuvm+0xe0>
  if(newsz < oldsz)
80106d7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d80:	0f 82 aa 00 00 00    	jb     80106e30 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
80106d86:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d92:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d95:	77 53                	ja     80106dea <allocuvm+0x8a>
80106d97:	e9 97 00 00 00       	jmp    80106e33 <allocuvm+0xd3>
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106da0:	89 1c 24             	mov    %ebx,(%esp)
80106da3:	31 d2                	xor    %edx,%edx
80106da5:	b8 00 10 00 00       	mov    $0x1000,%eax
80106daa:	89 54 24 04          	mov    %edx,0x4(%esp)
80106dae:	89 44 24 08          	mov    %eax,0x8(%esp)
80106db2:	e8 e9 d9 ff ff       	call   801047a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106db7:	b9 06 00 00 00       	mov    $0x6,%ecx
80106dbc:	89 f2                	mov    %esi,%edx
80106dbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106dc2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dc8:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dcd:	89 04 24             	mov    %eax,(%esp)
80106dd0:	89 f8                	mov    %edi,%eax
80106dd2:	e8 59 fb ff ff       	call   80106930 <mappages>
80106dd7:	85 c0                	test   %eax,%eax
80106dd9:	0f 88 81 00 00 00    	js     80106e60 <allocuvm+0x100>
  for(; a < newsz; a += PGSIZE){
80106ddf:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106de5:	39 75 10             	cmp    %esi,0x10(%ebp)
80106de8:	76 49                	jbe    80106e33 <allocuvm+0xd3>
    mem = kalloc();
80106dea:	e8 51 b9 ff ff       	call   80102740 <kalloc>
    if(mem == 0){
80106def:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106df1:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106df3:	75 ab                	jne    80106da0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106df5:	c7 04 24 a9 7b 10 80 	movl   $0x80107ba9,(%esp)
80106dfc:	e8 7f 98 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80106e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e04:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e07:	74 37                	je     80106e40 <allocuvm+0xe0>
80106e09:	8b 55 10             	mov    0x10(%ebp),%edx
80106e0c:	89 c1                	mov    %eax,%ecx
80106e0e:	89 f8                	mov    %edi,%eax
80106e10:	e8 ab fb ff ff       	call   801069c0 <deallocuvm.part.0>
      return 0;
80106e15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e1f:	83 c4 2c             	add    $0x2c,%esp
80106e22:	5b                   	pop    %ebx
80106e23:	5e                   	pop    %esi
80106e24:	5f                   	pop    %edi
80106e25:	5d                   	pop    %ebp
80106e26:	c3                   	ret    
80106e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e36:	83 c4 2c             	add    $0x2c,%esp
80106e39:	5b                   	pop    %ebx
80106e3a:	5e                   	pop    %esi
80106e3b:	5f                   	pop    %edi
80106e3c:	5d                   	pop    %ebp
80106e3d:	c3                   	ret    
80106e3e:	66 90                	xchg   %ax,%ax
    return 0;
80106e40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e4a:	83 c4 2c             	add    $0x2c,%esp
80106e4d:	5b                   	pop    %ebx
80106e4e:	5e                   	pop    %esi
80106e4f:	5f                   	pop    %edi
80106e50:	5d                   	pop    %ebp
80106e51:	c3                   	ret    
80106e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e60:	c7 04 24 c1 7b 10 80 	movl   $0x80107bc1,(%esp)
80106e67:	e8 14 98 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80106e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e6f:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e72:	74 0c                	je     80106e80 <allocuvm+0x120>
80106e74:	8b 55 10             	mov    0x10(%ebp),%edx
80106e77:	89 c1                	mov    %eax,%ecx
80106e79:	89 f8                	mov    %edi,%eax
80106e7b:	e8 40 fb ff ff       	call   801069c0 <deallocuvm.part.0>
      kfree(mem);
80106e80:	89 1c 24             	mov    %ebx,(%esp)
80106e83:	e8 f8 b6 ff ff       	call   80102580 <kfree>
      return 0;
80106e88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e92:	83 c4 2c             	add    $0x2c,%esp
80106e95:	5b                   	pop    %ebx
80106e96:	5e                   	pop    %esi
80106e97:	5f                   	pop    %edi
80106e98:	5d                   	pop    %ebp
80106e99:	c3                   	ret    
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ea0 <deallocuvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ea6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106eac:	39 d1                	cmp    %edx,%ecx
80106eae:	73 10                	jae    80106ec0 <deallocuvm+0x20>
}
80106eb0:	5d                   	pop    %ebp
80106eb1:	e9 0a fb ff ff       	jmp    801069c0 <deallocuvm.part.0>
80106eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi
80106ec0:	5d                   	pop    %ebp
80106ec1:	89 d0                	mov    %edx,%eax
80106ec3:	c3                   	ret    
80106ec4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ecf:	90                   	nop

80106ed0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106edc:	85 f6                	test   %esi,%esi
80106ede:	74 55                	je     80106f35 <freevm+0x65>
  if(newsz >= oldsz)
80106ee0:	31 c9                	xor    %ecx,%ecx
80106ee2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ee7:	89 f0                	mov    %esi,%eax
80106ee9:	89 f3                	mov    %esi,%ebx
80106eeb:	e8 d0 fa ff ff       	call   801069c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ef0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ef6:	eb 0f                	jmp    80106f07 <freevm+0x37>
80106ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eff:	90                   	nop
80106f00:	83 c3 04             	add    $0x4,%ebx
80106f03:	39 df                	cmp    %ebx,%edi
80106f05:	74 1f                	je     80106f26 <freevm+0x56>
    if(pgdir[i] & PTE_P){
80106f07:	8b 03                	mov    (%ebx),%eax
80106f09:	a8 01                	test   $0x1,%al
80106f0b:	74 f3                	je     80106f00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f12:	83 c3 04             	add    $0x4,%ebx
80106f15:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f1a:	89 04 24             	mov    %eax,(%esp)
80106f1d:	e8 5e b6 ff ff       	call   80102580 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106f22:	39 df                	cmp    %ebx,%edi
80106f24:	75 e1                	jne    80106f07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f29:	83 c4 1c             	add    $0x1c,%esp
80106f2c:	5b                   	pop    %ebx
80106f2d:	5e                   	pop    %esi
80106f2e:	5f                   	pop    %edi
80106f2f:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f30:	e9 4b b6 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80106f35:	c7 04 24 dd 7b 10 80 	movl   $0x80107bdd,(%esp)
80106f3c:	e8 1f 94 ff ff       	call   80100360 <panic>
80106f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4f:	90                   	nop

80106f50 <setupkvm>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	56                   	push   %esi
80106f54:	53                   	push   %ebx
80106f55:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f58:	e8 e3 b7 ff ff       	call   80102740 <kalloc>
80106f5d:	85 c0                	test   %eax,%eax
80106f5f:	89 c6                	mov    %eax,%esi
80106f61:	74 46                	je     80106fa9 <setupkvm+0x59>
  memset(pgdir, 0, PGSIZE);
80106f63:	89 34 24             	mov    %esi,(%esp)
80106f66:	b8 00 10 00 00       	mov    $0x1000,%eax
80106f6b:	31 d2                	xor    %edx,%edx
80106f6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f71:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f76:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f7a:	e8 21 d8 ff ff       	call   801047a0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f7f:	8b 53 0c             	mov    0xc(%ebx),%edx
                (uint)k->phys_start, k->perm) < 0) {
80106f82:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f85:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f88:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f8c:	8b 13                	mov    (%ebx),%edx
80106f8e:	89 04 24             	mov    %eax,(%esp)
80106f91:	29 c1                	sub    %eax,%ecx
80106f93:	89 f0                	mov    %esi,%eax
80106f95:	e8 96 f9 ff ff       	call   80106930 <mappages>
80106f9a:	85 c0                	test   %eax,%eax
80106f9c:	78 22                	js     80106fc0 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f9e:	83 c3 10             	add    $0x10,%ebx
80106fa1:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fa7:	75 d6                	jne    80106f7f <setupkvm+0x2f>
}
80106fa9:	83 c4 10             	add    $0x10,%esp
80106fac:	89 f0                	mov    %esi,%eax
80106fae:	5b                   	pop    %ebx
80106faf:	5e                   	pop    %esi
80106fb0:	5d                   	pop    %ebp
80106fb1:	c3                   	ret    
80106fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106fc0:	89 34 24             	mov    %esi,(%esp)
      return 0;
80106fc3:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106fc5:	e8 06 ff ff ff       	call   80106ed0 <freevm>
}
80106fca:	83 c4 10             	add    $0x10,%esp
80106fcd:	89 f0                	mov    %esi,%eax
80106fcf:	5b                   	pop    %ebx
80106fd0:	5e                   	pop    %esi
80106fd1:	5d                   	pop    %ebp
80106fd2:	c3                   	ret    
80106fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fe0 <kvmalloc>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fe6:	e8 65 ff ff ff       	call   80106f50 <setupkvm>
80106feb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ff0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ff5:	0f 22 d8             	mov    %eax,%cr3
}
80106ff8:	c9                   	leave  
80106ff9:	c3                   	ret    
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107000 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107000:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107001:	31 c9                	xor    %ecx,%ecx
{
80107003:	89 e5                	mov    %esp,%ebp
80107005:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107008:	8b 55 0c             	mov    0xc(%ebp),%edx
8010700b:	8b 45 08             	mov    0x8(%ebp),%eax
8010700e:	e8 7d f8 ff ff       	call   80106890 <walkpgdir>
  if(pte == 0)
80107013:	85 c0                	test   %eax,%eax
80107015:	74 05                	je     8010701c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107017:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010701a:	c9                   	leave  
8010701b:	c3                   	ret    
    panic("clearpteu");
8010701c:	c7 04 24 ee 7b 10 80 	movl   $0x80107bee,(%esp)
80107023:	e8 38 93 ff ff       	call   80100360 <panic>
80107028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702f:	90                   	nop

80107030 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107039:	e8 12 ff ff ff       	call   80106f50 <setupkvm>
8010703e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107041:	85 c0                	test   %eax,%eax
80107043:	0f 84 a3 00 00 00    	je     801070ec <copyuvm+0xbc>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107049:	8b 55 0c             	mov    0xc(%ebp),%edx
8010704c:	85 d2                	test   %edx,%edx
8010704e:	0f 84 98 00 00 00    	je     801070ec <copyuvm+0xbc>
80107054:	31 ff                	xor    %edi,%edi
80107056:	eb 50                	jmp    801070a8 <copyuvm+0x78>
80107058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107060:	89 34 24             	mov    %esi,(%esp)
80107063:	b8 00 10 00 00       	mov    $0x1000,%eax
80107068:	89 44 24 08          	mov    %eax,0x8(%esp)
8010706c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010706f:	05 00 00 00 80       	add    $0x80000000,%eax
80107074:	89 44 24 04          	mov    %eax,0x4(%esp)
80107078:	e8 e3 d7 ff ff       	call   80104860 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010707d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107083:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107088:	89 04 24             	mov    %eax,(%esp)
8010708b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010708e:	89 fa                	mov    %edi,%edx
80107090:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80107094:	e8 97 f8 ff ff       	call   80106930 <mappages>
80107099:	85 c0                	test   %eax,%eax
8010709b:	78 63                	js     80107100 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
8010709d:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070a3:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801070a6:	76 44                	jbe    801070ec <copyuvm+0xbc>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070a8:	8b 45 08             	mov    0x8(%ebp),%eax
801070ab:	31 c9                	xor    %ecx,%ecx
801070ad:	89 fa                	mov    %edi,%edx
801070af:	e8 dc f7 ff ff       	call   80106890 <walkpgdir>
801070b4:	85 c0                	test   %eax,%eax
801070b6:	74 5e                	je     80107116 <copyuvm+0xe6>
    if(!(*pte & PTE_P))
801070b8:	8b 18                	mov    (%eax),%ebx
801070ba:	f6 c3 01             	test   $0x1,%bl
801070bd:	74 4b                	je     8010710a <copyuvm+0xda>
    pa = PTE_ADDR(*pte);
801070bf:	89 d8                	mov    %ebx,%eax
    flags = PTE_FLAGS(*pte);
801070c1:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801070c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801070cf:	e8 6c b6 ff ff       	call   80102740 <kalloc>
801070d4:	85 c0                	test   %eax,%eax
801070d6:	89 c6                	mov    %eax,%esi
801070d8:	75 86                	jne    80107060 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801070da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070dd:	89 04 24             	mov    %eax,(%esp)
801070e0:	e8 eb fd ff ff       	call   80106ed0 <freevm>
  return 0;
801070e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801070ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ef:	83 c4 2c             	add    $0x2c,%esp
801070f2:	5b                   	pop    %ebx
801070f3:	5e                   	pop    %esi
801070f4:	5f                   	pop    %edi
801070f5:	5d                   	pop    %ebp
801070f6:	c3                   	ret    
801070f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fe:	66 90                	xchg   %ax,%ax
      kfree(mem);
80107100:	89 34 24             	mov    %esi,(%esp)
80107103:	e8 78 b4 ff ff       	call   80102580 <kfree>
      goto bad;
80107108:	eb d0                	jmp    801070da <copyuvm+0xaa>
      panic("copyuvm: page not present");
8010710a:	c7 04 24 12 7c 10 80 	movl   $0x80107c12,(%esp)
80107111:	e8 4a 92 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80107116:	c7 04 24 f8 7b 10 80 	movl   $0x80107bf8,(%esp)
8010711d:	e8 3e 92 ff ff       	call   80100360 <panic>
80107122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107130 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107130:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107131:	31 c9                	xor    %ecx,%ecx
{
80107133:	89 e5                	mov    %esp,%ebp
80107135:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107138:	8b 55 0c             	mov    0xc(%ebp),%edx
8010713b:	8b 45 08             	mov    0x8(%ebp),%eax
8010713e:	e8 4d f7 ff ff       	call   80106890 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107143:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107145:	89 c2                	mov    %eax,%edx
80107147:	83 e2 05             	and    $0x5,%edx
8010714a:	83 fa 05             	cmp    $0x5,%edx
8010714d:	75 11                	jne    80107160 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
8010714f:	c9                   	leave  
  return (char*)P2V(PTE_ADDR(*pte));
80107150:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107155:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010715a:	c3                   	ret    
8010715b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop
80107160:	c9                   	leave  
    return 0;
80107161:	31 c0                	xor    %eax,%eax
}
80107163:	c3                   	ret    
80107164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010716f:	90                   	nop

80107170 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 1c             	sub    $0x1c,%esp
80107179:	8b 75 14             	mov    0x14(%ebp),%esi
8010717c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010717f:	85 f6                	test   %esi,%esi
80107181:	75 43                	jne    801071c6 <copyout+0x56>
80107183:	eb 7b                	jmp    80107200 <copyout+0x90>
80107185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107190:	8b 55 0c             	mov    0xc(%ebp),%edx
80107193:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107195:	8b 4d 10             	mov    0x10(%ebp),%ecx
    n = PGSIZE - (va - va0);
80107198:	29 d3                	sub    %edx,%ebx
    memmove(pa0 + (va - va0), buf, n);
8010719a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    n = PGSIZE - (va - va0);
8010719e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801071a4:	39 f3                	cmp    %esi,%ebx
801071a6:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801071a9:	29 fa                	sub    %edi,%edx
801071ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801071af:	01 c2                	add    %eax,%edx
801071b1:	89 14 24             	mov    %edx,(%esp)
801071b4:	e8 a7 d6 ff ff       	call   80104860 <memmove>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801071b9:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
    buf += n;
801071bf:	01 5d 10             	add    %ebx,0x10(%ebp)
  while(len > 0){
801071c2:	29 de                	sub    %ebx,%esi
801071c4:	74 3a                	je     80107200 <copyout+0x90>
    va0 = (uint)PGROUNDDOWN(va);
801071c6:	89 55 0c             	mov    %edx,0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801071c9:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
801071cc:	89 d7                	mov    %edx,%edi
801071ce:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801071d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
801071d8:	89 04 24             	mov    %eax,(%esp)
801071db:	e8 50 ff ff ff       	call   80107130 <uva2ka>
    if(pa0 == 0)
801071e0:	85 c0                	test   %eax,%eax
801071e2:	75 ac                	jne    80107190 <copyout+0x20>
  }
  return 0;
}
801071e4:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801071e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071ec:	5b                   	pop    %ebx
801071ed:	5e                   	pop    %esi
801071ee:	5f                   	pop    %edi
801071ef:	5d                   	pop    %ebp
801071f0:	c3                   	ret    
801071f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop
80107200:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80107203:	31 c0                	xor    %eax,%eax
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    

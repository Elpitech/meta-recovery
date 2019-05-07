#include <unistd.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/fcntl.h>
#include <linux/serio.h>
#include <errno.h>
#include <termios.h>

int main(int argc, char *argv[])
{
	int fd;
	unsigned long serio_type = SERIO_PS2SER;
	unsigned int ldisc_type = N_MOUSE;
	struct termios termios;
	char dummy_buf[8];
	int len;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s /dev/ttySX\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "Can't open %s\n", argv[1]);
		return 1;
	}
	if (tcgetattr(fd, &termios)) {
		perror("tcgetattr");
		return 1;
	}
	cfmakeraw(&termios);
	cfsetspeed(&termios, B115200);
	if (tcsetattr(fd, TCSANOW, &termios)) {
		perror("tcsetattr");
		return 1;
	}
	if (ioctl(fd, TIOCSETD, &ldisc_type)) {
		perror("TIOCSETD");
		return 1;
	}
	if (ioctl(fd, SPIOCSTYPE, &serio_type)) {
		fprintf(stderr, "ioctl failed\n");
		perror("ioctl");
		return 1;
	}

	if (fork())
		return 0;
	close(0); close(1); close(2);
	dup(fd); dup(fd); dup(fd); close(fd);
	len = read(0, dummy_buf, 8);
//	printf("read %d bytes\n", len);
	return 0;
}


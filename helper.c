#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <caml/mlvalues.h>

void help_write_float(value fd_, value f_)
{
	int fd = Int_val(fd_);
	double f = Double_val(f_);

	ssize_t ret = write(fd, &f, sizeof(f));

	if (ret != sizeof(f)) {
		fprintf(stderr, "write ret = %zd\n", ret);
	}
}

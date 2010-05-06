# fag, forums are gay
#
# Copyleft meh. [http://meh.doesntexist.org | meh.ffff@gmail.com]
#
# This file is part of fag.
#
# fag is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fag is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with fag. If not, see <http://www.gnu.org/licenses/>.

require 'syntaxhighlighter/language'

class SyntaxHighlighter

class Language

class Cpp < Language
    def initialize (content, options={})
        @regexes = {
            /^(\s*)(#.*)$/ => lambda {|match| "#{$1}<span class='cpp preprocessor'>#{Language.escape(match)}</span>"},

            /("([^\\"]|\\.)*")/m => lambda {|match| "<span class='cpp string'>#{Language.escape(match)}</span>"},
            /('(\\.|[^\\'])')/ => lambda {|match| "<span class='cpp char'>#{Language.escape(match)}</span>"},

            /(\/\*.*?\*\/)/m => lambda {|match| "<span class='cpp comment'>#{Language.escape(match)}</span>"},
            /(\/\/.*)$/ => lambda {|match| "<span class='cpp comment'>#{Language.escape(match)}</span>"},

            Cpp.keywords([
                'extern', 'const', 'static', 'inline', 'volatile', 'register', 'auto', 'signed', 'unsigned',
                'if', 'else', 'switch', 'case', 'defaul',
                'while', 'do', 'for', 'break', 'continue',
                'return', 'goto', 'typedef', 'sizeof', 'struct', 'union', 'enum',
                'asm', '__asm__',

                'class', 'public', 'protected', 'private', 'new', 'delete', 'virtual', 'operator', 'namespace', 'using',
            ]) => '\1<span class="c keyword">\2</span>\3',


            Cpp.types([
                'void', 'char', 'short', 'int', 'long', 'float', 'double',

                # stddef.h
                'ptrdiff_t', 'wchar_t', 'size_t',

                # stdarg.h
                'va_list',

                # stdint.h
                'int8_t', 'int16_t', 'int32_t', 'int64_t', 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t', 'int_least8_t', 'int_least16_t', 'int_least32_t', 'int_least64_t', 'uint_least8_t', 'uint_least16_t', 'uint_least32_t', 'uint_least64_t', 'int_fast8_t', 'int_fast16_t', 'int_fast32_t', 'int_fast64_t', 'uint_fast8_t', 'uint_fast16_t', 'uint_fast32_t', 'uint_fast64_t', 'intptr_t', 'uintptr_t', 'intmax_t', 'uintmax_t',

                # stdlib.h
                'div_t', 'ldiv_t', 'lldiv_t',

                # stdio.h
                'FILE', 'fpos_t',

                # math.h
                'float_t', 'double_t',

                # time.h
                'clock_t', 'clock_id_t', 'timer_t', 'tm', 'time_t', 'timespec',

                # signal.h
                'sig_atomic_t', 'sigset_t', 'pid_t', 'sigevent', 'sigval', 'sigaction', 'ucontext_t', 'mcontext_t', 'stack_t', 'sigstack', 'siginfo_t', 
            ]) => '\1<span class="c type">\2</span>\3',

            Cpp.constants([
                # stddef.h
                'NULL',

                # stdint.h
                'INT8_MIN', 'INT16_MIN', 'INT32_MIN', 'INT64_MIN', 'INT8_MAX', 'INT16_MAX', 'INT32_MAX', 'INT64_MAX', 'UINT8_MIN', 'UINT16_MIN', 'UINT32_MIN', 'UINT64_MIN', 'UINT8_MAX', 'UINT16_MAX', 'UINT32_MAX', 'UINT64_MAX', 'PTRDIFF_MIN', 'PTRDIFF_MAX', 'SIG_ATOMIC_MIN', 'SIG_ATOMIC_MAX', 'SIZE_MAX', 'WCHAR_MIN', 'WCHAR_MAX', 'WINT_MIN', 'WINT_MAX', 

                # stdlib.h
                'EXIT_SUCCESS', 'EXIT_FAILURE', 'RAND_MAX', 'MB_CUR_MAX''WNOHANG', 'WUNTRACED', 'WEXITSTATUS', 'WIFEXITED', 'WIFSIGNALED', 'WIFSTOPPED', 'WSTOPSIG', 'WTERMSIG',

                # stdio.h
                'stdin', 'stdout', 'stderr', 'BUFSIZ', '_IOFBF', '_IOLBF', '_IONBF', 'L_ctermid', 'L_tmpnam', 'SEEK_CUR', 'SEEK_END', 'SEEK_SET', 'EOF', 'P_tmpdir',

                # math.h
                'M_E', 'M_LOG2E', 'M_LOG10E', 'M_LN2', 'M_LN10', 'M_PI', 'M_PI_2', 'M_PI_4', 'M_1_PI', 'M_2_PI', 'M_2_SQRTPI', 'M_SQRT2', 'M_SQRT1_2', 'MAXFLOAT', 'HUGE_VAL', 'HUFE_VALF', 'INFINITY', 'NAN', 'FP_INFINITE', 'FP_NAN', 'FP_NORMAL', 'FP_SUBNORMAL', 'FP_ZERO', 'FP_FAST_FMA', 'FP_FAST_FMAF', 'FP_FAST_FMAL', 'FP_ILOGB0', 'FP_ILOGBNAN', 'MATH_ERRNO', 'MATH_ERREXCEPT', 'math_errhandling',

                # time.h
                'CLOCKS_PER_SEC', 'CLOCK_PROCESS_CPUTIME_ID', 'CLOCK_THREAD_CPUTIME_ID', 'CLOCK_REALTIME', 'TIMER_ABSTIME', 'CLOCK_MONOTONIC',

                # errno.h
                'errno', 'E2BIG', 'EACCES', 'EADDRINUSE', 'EADDRNOTAVAIL', 'EAFNOSUPPORT', 'EAGAIN', 'EALREADY', 'EBADE', 'EBADF', 'EBADFD', 'EBADMSG', 'EBADR', 'EBADRQC', 'EBADSLT', 'EBUSY', 'ECANCELED', 'ECHILD', 'ECHRNG', 'ECOMM', 'ECONNABORTED', 'ECONNREFUSED', 'ECONNRESET', 'EDEADLK', 'EDEADLOCK', 'EDESTADDREQ', 'EDOM', 'EDQUOT', 'EEXIST', 'EFAULT', 'EFBIG', 'EHOSTDOWN', 'EHOSTUNREACH', 'EIDRM', 'EILSEQ', 'EINPROGRESS', 'EINTR', 'EINVAL', 'EIO', 'EISCONN', 'EISDIR', 'EISNAM', 'EKEYEXPIRED', 'EKEYREJECTED', 'EKEYREVOKED', 'EL2HLT', 'EL2NSYNC', 'EL3HLT', 'EL3RST', 'ELIBACC', 'ELIBBAD', 'ELIBMAX', 'ELIBSCN', 'ELIBEXEC', 'ELOOP', 'EMEDIUMTYPE', 'EMFILE', 'EMLINK', 'EMSGSIZE', 'EMULTIHOP', 'ENAMETOOLONG', 'ENETDOWN', 'ENETRESET', 'ENETUNREACH', 'ENFILE', 'ENOBUFS', 'ENODATA', 'ENODEV', 'ENOENT', 'ENOEXEC', 'ENOKEY', 'ENOLCK', 'ENOLINK', 'ENOMEDIUM', 'ENOMEM', 'ENOMSG', 'ENONET', 'ENOPKG', 'ENOPROTOOPT', 'ENOSPC', 'ENOSR', 'ENOSTR', 'ENOSYS', 'ENOTBLK', 'ENOTCONN', 'ENOTDIR', 'ENOTEMPTY', 'ENOTSOCK', 'ENOTSUP', 'ENOTTY', 'ENOTUNIQ', 'ENXIO', 'EOPNOTSUPP', '(ENOTSUP', 'be', 'EOVERFLOW', 'EPERM', 'EPFNOSUPPORT', 'EPIPE', 'EPROTO', 'EPROTONOSUPPORT', 'EPROTOTYPE', 'ERANGE', 'EREMCHG', 'EREMOTE', 'EREMOTEIO', 'ERESTART', 'EROFS', 'ESHUTDOWN', 'ESPIPE', 'ESOCKTNOSUPPORT', 'ESRCH', 'ESTALE', 'This', 'ESTRPIPE', 'ETIME', '(POSIX.1', 'ETIMEDOUT', 'ETXTBSY', 'EUCLEAN', 'EUNATCH', 'EUSERS', 'EWOULDBLOCK', 'EXDEV', 'EXFULL', 'ESTALE', 'ESTRPIPE', 'ETIME', 'ETIMEDOUT', 'ETXTBSY', 'EUCLEAN', 'EUNATCH', 'EUSERS', 'UWOULDBLOCK', 'EXDEV', 'EXFULL',

                # signal.h
                'SIG_DFL', 'SIG_ERR', 'SIG_HOLD', 'SIG_IGN', 'SIGEV_NONE', 'SIGEV_SIGNAL', 'SIGEV_THREAD', 'SIGABRT', 'SIGALRM', 'SIGBUS', 'SIGCHLD', 'SIGCONT', 'SIGFPE', 'SIGHUP', 'SIGILL', 'SIGINT', 'SIGKILL', 'SIGPIPE', 'SIGQUIT', 'SIGSEGV', 'SIGSTOP', 'SIGTERM' ,'SIGTSTP', 'SIGTTIN', 'SIGTTOU', 'SIGUSR1', 'SIGUSR2', 'SIGPOLL', 'SIGPROF', 'SIGSYS', 'SIGTRAP', 'SIGURG', 'SIGVTALRM', 'SIGXCPU', 'SIGXFSZ', 'SA_NOCLDSTOP', 'SIG_BOCK', 'SIG_UNBLOCK', 'SIG_SETMASK', 'SA_ONSTACK', 'SA_RESETHAND', 'SA_RESTART', 'SA_SIGINFO', 'SA_NOCLDWAIT', 'SA_NODEFER', 'SS_ONSTACK', 'SS_DISABLE', 'MINSIGSTKSZ', 'SIGSTKSZ', 'ILL_ILLOPC', 'ILL_ILLOPN', 'ILL_ILLADR', 'ILL_ILLTRP', 'ILL_PRVOPC', 'ILL_PRVREG', 'ILL_COPROC', 'ILL_BADSTK', 'FPE_INTDIV', 'FPE_INTOVF', 'FPE_FLTDIV', 'FPE_FLTOVF', 'FPE_FLTUND', 'FPE_FLTRES', 'FPE_FLTINV', 'FPE_FLTSUB', 'BUS_ADRALN', 'BUS_ADRERR', 'BUS_OBJERR', 'TRAP_BRKPT', 'TRAP_TRACE', 'CLD_EXITED', 'CLD_KILLED', 'CLD_DUMPED', 'CLD_TRAPPED', 'CLD_STOPPED', 'CLD_CONTINUED', 'POLL_IN', 'POLL_OUT', 'POLL_MSG', 'POLL_ERR', 'POLL_PRI', 'POLL_HUP', 'SI_USER', 'SI_QUEUE', 'SI_TIMER', 'SI_ASYNCIO', 'SI_MESGQ',
            ]) => '\1<span class="c constant">\2</span>\3',
            
            Cpp.functions([
                # stddef.h
                'offsetof',

                # stdarg.h
                'va_start', 'va_arg', 'va_end',

                # stdlib.h
                '_Exit', 'a64l', 'abort', 'abs', 'atexit', 'atof', 'atoi', 'atol', 'atoll', 'bsearch', 'calloc', 'div', 'drand48', 'ecvt', 'erand48', 'exit', 'fcvt', 'free', 'gcvt', 'getenv', 'getsbopt', 'grantpt', 'initstate', 'jrand48', 'l64a', 'labs', 'lcong48', 'ldiv', 'llabs', 'lldiv', 'lrand48', 'malloc', 'mblen', 'mbstowcs', 'mbtowc', 'mktemp', 'mkstemp', 'mrand48', 'nrand48', 'posix_memalign', 'posix_openpt', 'ptsname', 'putenv', 'qsort', 'rand', 'rand_r', 'random', 'realloc', 'realpath', 'seed48', 'setenv', 'setkey', 'setstate', 'srand', 'srand48', 'srandom', 'strtod', 'strtof', 'strtol', 'strtold', 'strtoll', 'strtoul', 'strtoull', 'system', 'unlockpt', 'unsetenv', 'wcstombs', 'wctomb',

                # stdio.h
                'clearerr', 'ctermid', 'fclose', 'fdopen', 'feof', 'ferror', 'fflush', 'fgetc', 'fgetpos', 'fgets', 'fileno', 'flockfile', 'fopen', 'fprintf', 'fputc', 'fputs', 'fread', 'freopen', 'fscanf', 'fseek', 'fseeko', 'fsetpos', 'ftell', 'ftello', 'ftrylockfile', 'funlockfile', 'fwrite', 'getc', 'getchar', 'getc_unlocked', 'getchar_unlocked', 'gets', 'pclose', 'perror', 'popen', 'printf', 'putc', 'putchar', 'putc_unlocked', 'putchar_unlocked', 'puts', 'remove', 'rename', 'rewind', 'scanf', 'setbuf', 'setvbuf', 'snprintf', 'sprintf', 'sscanf', 'tempnam', 'tmpfile', 'tmpnam', 'ungetc', 'vfprintf', 'vfscanf', 'vprintf', 'vscanf', 'vsnprintf', 'vsprintf', 'vsscanf',

                # ctype.h
                'isalnum', 'isalpha', 'isascii', 'isblank', 'iscntrl', 'isdigit', 'isgraph', 'islower', 'isprint', 'ispunct', 'isspace', 'isupper', 'isxdigit', 'toascii', 'tolower', 'toupper', '_toupper', '_tolower',

                # string.h
                'memccpy', 'memchr', 'memcmp', 'memcpy', 'memmove', 'memset', 'strat', 'strchr', 'strcmp', 'strcoll', 'strcpy', 'strcspn', 'strdup', 'strerror', 'strerror_r', 'strlen', 'strncat', 'strncmp', 'strncpy', 'strpbrk', 'strrchr', 'strspn', 'strstr', 'strtok', 'strtok_r', 'strxfrm',

                # math.h
                'fpclassify', 'isfinite', 'isinf', 'isnan', 'isnormal', 'signbit', 'isgreater', 'isgreaterequal', 'isless', 'islessequal', 'islessgreater', 'isunordered', 'acos', 'acosf', 'acosh', 'acoshf', 'acoshl', 'acosl', 'asin', 'asinf', 'asinh', 'asinhf', 'asinhl', 'asinl', 'atan', 'atan2', 'atan2f', 'atan2l', 'atanf', 'atanh', 'atanhf', 'atanhl', 'atanl', 'cbrt', 'cbrtf', 'cbrtl', 'ceil', 'ceilf', 'ceill', 'copysign', 'copysignf', 'cos', 'cosf', 'cosh', 'coshf', 'coshl', 'cosl', 'erf', 'erfc', 'erfcf', 'erff', 'erfl', 'exp', 'exp2', 'exp2f', 'exp2l', 'epf', 'expl', 'expm1', 'expm1f', 'expm1l', 'fabs', 'fabsl', 'fdim', 'fdimf', 'fdiml', 'floor', 'floorf', 'floorl', 'fma', 'fmaf', 'fmal', 'fmax', 'fmaxf', 'fmaxl', 'fmin', 'fminf', 'fminl', 'fmod', 'fmodf', 'fmodl', 'frexp', 'frexpf', 'frexpl', 'hypot', 'hypotf', 'hypotl', 'ilogb', 'ilogbf', 'ilogbl', 'j0', 'j1', 'jn', 'ldexp', 'ldexpf', 'ldexpl', 'lgamma', 'lgammaf', 'lgammal', 'llrint', 'llrintf', 'llrintl', 'llround', 'llroundf', 'llroundl', 'log', 'log10', 'log10f', 'log10l', 'log1p', 'log1pf', 'log2', 'log2f', 'log2l', 'logb', 'logbf', 'logf', 'logl', 'lrint', 'lrintf', 'lrintl', 'lround', 'lroundf', 'lroundl', 'modf', 'modff', 'modfl', 'nan', 'nanf', 'nanl', 'nearbyint', 'nearbyintf', 'nearbyintl', 'nextafter', 'nextafterf', 'nextafterl', 'nexttoward', 'nexttowardf', 'nexttowardl', 'pow', 'powf', 'powl', 'remainder', 'remainderf', 'remainderl', 'remquo', 'remquof', 'remquol', 'rint', 'rintf', 'rintl', 'round', 'roundf', 'roundl', 'scalb', 'scalbln', 'scalblnf', 'scalblnl', 'scalbn', 'scalbnf', 'scalbnl', 'sin', 'sinf', 'sinh', 'sinhf', 'sinhl', 'sinl', 'sqrt', 'sqrtf', 'sqrtl', 'tan', 'tanf', 'tanh', 'tanhf', 'tanhl', 'tanl', 'tgamma', 'tgammaf', 'tgammal', 'trunc', 'truncf', 'truncl', 'y0', 'y1', 'yn',

                # time.h
                'asctime', 'asctime_r', 'clock', 'clok_getcpuclockid', 'clock_getres', 'clock_gettime', 'clock_nanosleep', 'clock_settime', 'ctime', 'difftime', 'getdate', 'gmtime', 'gmtime_r', 'localtime', 'mktime', 'nanosleep', 'strftime', 'strptime', 'time', 'timer_create', 'timer_delete', 'timer_gettime', 'timer_getoverrun', 'timer_settime', 'tzset',

                # assert.h
                'assert',

                # signal.h
                'bsd_signal', 'kill', 'killpg', 'pthread_kill', 'pthread_sigmask', 'raise', 'sigaction', 'sigaddset', 'sigaltstack', 'sigdelset', 'sigemptyset', 'sigfillset', 'sighold', 'sigignore', 'siginterrupt', 'sigismember', 'signal', 'sigpause', 'sigpending', 'sigprocmask', 'sigqueue', 'sigrelse', 'sigset', 'sigsuspend', 'sigtimedwait', 'sigwait', 'sigwaitinfo',
            ]) => '\1<span class="c function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|[(){}])(#{keywords[1, keywords.length]})([{()}]|\*|\s|$)/
    end

    def self.types (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\))(#{result[1, result.length]})(\{|\(|\)|\*|\s|$)/
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|[-\[\]\)\(~^@\/%|=+*!?\.\-,;:]|&amp;|&lt;|&gt;)(#{result[1, result.length]})([-\[\]\)\(~^@\/%|=+*!?\.\-,;:]|&amp;|&lt;|&gt;|\s|\(|$)/
    end

    def self.constants (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|[-\[\]\)\(~^@\/%|=+*!?\.\-,;:]|&amp;|&lt;|&gt;)(#{result[1, result.length]})([-\[\]\)\(~^@\/%|=+*!?\.\-,;:]|&amp;|&lt;|&gt;|\s|$)/
    end
end

end

end

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void say_hello() {
    printf("Hello from C!\n");
}

int min(int a, int b, int c) {
    if (a <= b && a <= c) return a;
    if (b <= a && b <= c) return b;
    return c;
}

int EditDistance(const char *s1, const char *s2) {
    int len1 = strlen(s1);
    int len2 = strlen(s2);
    int **d = (int **)malloc((len1 + 1) * sizeof(int *));

    for (int i = 0; i <= len1; i++) {
        d[i] = (int *)malloc((len2 + 1) * sizeof(int));
    }

    for (int i = 0; i <= len1; i++) {
        d[i][0] = i;
    }

    for (int j = 0; j <= len2; j++) {
        d[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
        for (int j = 1; j <= len2; j++) {
            int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
            d[i][j] = min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);

            if (i > 1 && j > 1 && s1[i - 1] == s2[j - 2] && s1[i - 2] == s2[j - 1]) {
                d[i][j] = (d[i][j] < d[i - 2][j - 2] + cost) ? d[i][j] : d[i - 2][j - 2] + cost;
            }
        }
    }

    int distance = d[len1][len2];

    for (int i = 0; i <= len1; i++) {
        free(d[i]);
    }
    free(d);

    return distance;
}
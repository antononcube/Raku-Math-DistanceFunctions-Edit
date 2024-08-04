#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void say_hello() {
    printf("Hello from C!\n");
}

int min(int a, int b) {
    return (a < b) ? a : b;
}

int min3(int a, int b, int c) {
    return min(a, min(b, c));
}


void copyStringToIntArray(const char *str, int *intArray) {
    while (*str) {
        *intArray++ = (int)*str++;
    }
    *intArray = 0; // Null-terminate the integer array
}

int EditDistanceArray(const int *s1, const int len1, const int *s2, const int len2) {
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
            int cost = (s1[i-1] == s2[j-1]) ? 0 : 1;

            // The pseudo code part
            d[i][j] = min3(d[i-1][j] + 1,             // deletion
                           d[i][j-1] + 1,             // insertion
                           d[i-1][j-1] + cost);       // substitution

            if (i > 1 && j > 1 && s1[i-1] == s2[j-2] && s1[i-2] == s2[j-1]) {
                d[i][j] = min(d[i][j], d[i-2][j-2] + cost); // transposition
            }
        }
    }

    int result = d[len1][len2];

    for (int i = 0; i <= len1; i++) {
        free(d[i]);
    }
    free(d);

    return result;
}

int EditDistance(const char *s1, const char *s2) {
    int len1 = strlen(s1);
    int len2 = strlen(s2);
    int *intArray1 = (int *)malloc((len1 + 1) * sizeof(int));
    int *intArray2 = (int *)malloc((len2 + 1) * sizeof(int));

    copyStringToIntArray(s1, intArray1);
    copyStringToIntArray(s2, intArray2);

    int distance = EditDistanceArray(intArray1, len1, intArray2, len2);

    free(intArray1);
    free(intArray2);

    return distance;
}
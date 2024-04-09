# Servo control doodad

## `0x050`: Servo select

There are 16 bits available to select motors. Each bit corresponds to a motor. To select a motor set its corresponding bit to 1. Motor selection is latched until it is changed.

| Input  | Servo(s) |
| ------ | -------- |
| `0001` | 0        |
| `0100` | 2        |
| `1010` | 1, 3     |
| `1100` | 2, 3     |

### Example:

To select servos 2 and 4:

```asm
LOADI   &b1010
OUT     0x050
```

Any future commands will only affect servos 2 and 4 until the selection is changed.

## `0x051` Set angle

Servos have a default range of 180 degrees, but this can be changed. The angle is set in 2 ways:

1. degrees
2. percentage of range

Servos can be directed to move to an absolute position or relatively to the current position. The current positions can be read via (ANOTHER COMMAND). Angles are 8 bit unsigned integers.

Angles beyond the maximum range, when setting absolutely, are clamped to the maximum/minimum angles. When setting relatively, the angle is added to the current position and wraps around.

| Bit | Use                           |
| --- | ----------------------------- |
| 15  | `0`: degrees, `1`: percentage |
| 14  | `0`: absolute, `1`: relative  |
| 13  |                               |
| 12  |                               |
| 11  |                               |
| 10  |                               |
| 9   |                               |

| Bit | Use (deg)  | Use (%)    |
| --- | ---------- | ---------- |
| 8   | `Angle[8]` |            |
| 7   | `Angle[7]` | `Angle[7]` |
| 6   | `Angle[6]` | `Angle[6]` |
| 5   | `Angle[5]` | `Angle[5]` |
| 4   | `Angle[4]` | `Angle[4]` |
| 3   | `Angle[3]` | `Angle[3]` |
| 2   | `Angle[2]` | `Angle[2]` |
| 1   | `Angle[1]` | `Angle[1]` |
| 0   | `Angle[0]` | `Angle[0]` |

## `0x052` Set velocity

Servo velocity can be set in 2 ways:

1. degrees per (ms or sec)
2. time to complete movement (ms or sec)

| Bit | Use                              |
| --- | -------------------------------- |
| 15  | `0`: degrees/time, `1`: absolute |
| 14  | `0`: ms, `1`: sec                |
| 13  |                                  |
| 12  |                                  |
| 11  |                                  |
| 10  |                                  |
| 9   |                                  |
| 8   |                                  |
| 7   | `Time[7]`                        |
| 6   | `Time[6]`                        |
| 5   | `Time[5]`                        |
| 4   | `Time[4]`                        |
| 3   | `Time[3]`                        |
| 2   | `Time[2]`                        |
| 1   | `Time[1]`                        |
| 0   | `Time[0]`                        |

## `0x053` Set ramping/acceleration

## `0x05D` Fetch current position

## `0x05E` Execute movement

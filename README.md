# I2C_ADDRESS_TRANSLATOR
This design functions as a "man-in-the-middle" device on an I2C bus. It listens for a specific virtual address from a master and, upon detection, initiates a new transaction to a slave device using a different physical address. This is invaluable for resolving address conflicts when multiple identical slave devices are required on the same bus.

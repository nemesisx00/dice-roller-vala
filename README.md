# Dice Roller (Vala)

This is a simple dice roller application written in Vala, utilizing GTK4 to construct the GUI.

## Getting Started

### Requirements

- [GTK4](https://www.gtk.org)
- [Meson](https://mesonbuild.com)
- [Ninja](https://ninja-build.org)
- [Vala](https://vala.dev)

### Compiling and Running

Navigate to the project directory and generate the build script by running the following command:

```
meson setup builddir
```

Then navigate into the `builddir` directory and execute the build script by running the following command:

```
ninja
```

An executable named `diceroller` will be created in the `builddir` directory, ready to be used.

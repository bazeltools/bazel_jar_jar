package com.github.johnynek.jarjar.integration;

public class JarJarFailedException extends RuntimeException {
  public JarJarFailedException(Exception ex) {
    super("JarJar did not exit successfully " + ex.getMessage());
  }
}

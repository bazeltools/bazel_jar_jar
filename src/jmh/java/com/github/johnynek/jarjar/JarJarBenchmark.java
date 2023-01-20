package com.github.johnynek.jarjar;

import com.google.devtools.build.runfiles.Runfiles;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.State;

@BenchmarkMode(Mode.AverageTime)
@State(Scope.Benchmark)
public class JarJarBenchmark {

  Main main = new Main();

  File rulesFile;
  File jarFile;
  File outFile;

  public JarJarBenchmark() {
    try {
      Runfiles runfiles = Runfiles.create();
      rulesFile = new File(runfiles.rlocation(
          "com_github_johnynek_bazel_jar_jar/src/jmh/java/com/github/johnynek/jarjar/shade.jarjar"));
      jarFile = new File(runfiles.rlocation(
          "com_github_johnynek_bazel_jar_jar/src/jmh/java/com/github/johnynek/jarjar/input_deploy.jar"));
      outFile = Files.createTempFile(null, ".jar").toFile();
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  @Benchmark
  public void applyJarJar() throws IOException {
    main.process(rulesFile, jarFile, outFile);
  }
}
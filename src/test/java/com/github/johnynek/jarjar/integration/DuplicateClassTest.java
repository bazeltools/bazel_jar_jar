package com.github.johnynek.jarjar.integration;


import com.google.devtools.build.runfiles.Runfiles;
import org.junit.Test;
import java.util.Map;
import java.util.List;
import java.util.jar.JarOutputStream;
import java.util.jar.JarFile;
import java.util.jar.JarEntry;
import java.util.HashMap;
import java.util.Enumeration;
import java.util.*;
import java.io.*;

import static org.junit.Assert.assertTrue;

public class DuplicateClassTest extends IntegrationTestBase {

    private static final String DUPLICATE_CLASSES_JAR =
      "com_github_johnynek_bazel_jar_jar/src/test/java/com/github/johnynek/jarjar/integration/duplicate_class.jar";

    @Test
    public void testErrorOnDuplicateClasses() throws Exception {
      Runfiles runfiles = Runfiles.create();
      File duplicateClassJar = new File(runfiles.rlocation(DUPLICATE_CLASSES_JAR));
      assertTrue("Test is misconfigured if we can't find this", duplicateClassJar.exists());

      try {
          File shaded = shadeJar(duplicateClassJar, null, new String[] {
              "rule com.github.johnynek.jarjar.SingleClass com.github.johnynek.jarjar.ShadedClass"
          });
          assertTrue("Should have failed on duplicates", false);
      }
      catch (JarJarFailedException e) {
          assertTrue(e.getMessage().contains("Duplicate jar entry"));
      }
    }

    @SuppressWarnings("DoubleBraceInitialization")
    @Test
    public void ignoreDuplicateClasses() throws Exception {
      Runfiles runfiles = Runfiles.create();
      File duplicateClassJar = new File(runfiles.rlocation(DUPLICATE_CLASSES_JAR));
      assertTrue("Test is misconfigured if we can't find this", duplicateClassJar.exists());

      File shaded = shadeJar(duplicateClassJar, new HashMap<String, String>() {{
        put("duplicateClassToWarn", "true");
        }}, new String[] {
          "rule com.github.johnynek.jarjar.SingleClass com.github.johnynek.jarjar.ShadedClass"
      });
      assertTrue("Should have worked", shaded.exists());

    }


}

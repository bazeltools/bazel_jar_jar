package com.github.johnynek.jarjar.integration;


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

  @Test
  public void testErrorOnDuplicateClasses() throws Exception {
    File duplicateClassJar = new File("src/test/java/com/github/johnynek/jarjar/integration/duplicate_class.jar");
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


}

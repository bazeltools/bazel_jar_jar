package com.github.johnynek.jarjar;

import java.util.jar.JarEntry;
import junit.framework.TestCase;
import org.junit.Test;
import com.github.johnynek.jarjar.util.StandaloneJarProcessor;
import java.util.jar.JarOutputStream;
import java.util.jar.JarInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;

public class TimestampFixTest extends TestCase {
    @Test
    public void testTimestampFix() throws java.io.IOException {
      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      JarOutputStream out = new JarOutputStream(baos);
      JarEntry je = new JarEntry("foo.txt");
      // we can only have second resolution
      long nowSeconds = System.currentTimeMillis() / 1000;
      if ((nowSeconds & 1L) == 1L) {
        // make sure we have an even timestamp
        nowSeconds -= 1L;
      }
      long startTime = (nowSeconds * 1000);
      je.setTime(startTime); 
      out.putNextEntry(je);
      out.write(new byte[]{});
      out.close();
      JarInputStream in = new JarInputStream(new ByteArrayInputStream(baos.toByteArray()));
      je = in.getNextJarEntry();
      long readTime = StandaloneJarProcessor.fixTimestamp(je.getTime());
      assertEquals(startTime, readTime);
    }

}
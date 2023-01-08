/**
 * Copyright 2007 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.github.johnynek.jarjar;

import org.objectweb.asm.*;
import org.objectweb.asm.commons.*;
import java.util.*;
import java.util.regex.Pattern;

class PackageRemapper extends Remapper
{
    private static final String RESOURCE_SUFFIX = "RESOURCE";

    private static final Pattern ARRAY_FOR_NAME_PATTERN
        = Pattern.compile("\\[L[\\p{javaJavaIdentifierPart}\\.]+?;");

    private final List<Wildcard> wildcards;
    private final Map<String, String> typeCache = new HashMap<String, String>();
    private final Map<String, String> pathCache = new HashMap<String, String>();
    private final Map<String, String> valueCache = new HashMap<String, String>();
    private final boolean verbose;

    public PackageRemapper(List<Rule> ruleList, boolean verbose) {
        this.verbose = verbose;
        wildcards = PatternElement.createWildcards(ruleList);
    }

    // also used by KeepProcessor
    static boolean isArrayForName(String value) {
      return ARRAY_FOR_NAME_PATTERN.matcher(value).matches();
    }

    public String map(String key) {
        return typeCache.computeIfAbsent(key, this::replaceHelper);
    }

    public String mapPath(String path) {
        return pathCache.computeIfAbsent(path, this::computePath);
    }

    public Object mapValue(Object value) {
        if (value instanceof String) {
            return valueCache.computeIfAbsent((String) value, this::computeValue);
        }
        return super.mapValue(value);
    }

    private String computePath(String path) {
        String s = path;
        int slash = s.lastIndexOf('/');
        String end;
        if (slash < 0) {
            end = s;
            s = RESOURCE_SUFFIX;
        } else {
            end = s.substring(slash + 1);
            s = s.substring(0, slash + 1) + RESOURCE_SUFFIX;
        }
        boolean absolute = s.startsWith("/");
        if (absolute) s = s.substring(1);

        s = map(s);

        if (absolute) s = "/" + s;
        if (s.indexOf(RESOURCE_SUFFIX) < 0)
            return path;
        s = s.substring(0, s.length() - RESOURCE_SUFFIX.length()) + end;
        return s;
    }

    public String computeValue(String value) {
        String s = value;
        if (isArrayForName(s)) {
            String desc1 = s.replace('.', '/');
            String desc2 = mapDesc(desc1);
            if (!desc2.equals(desc1))
                return desc2.replace('/', '.');
        } else {
            s = mapPath(s);
            if (s.equals(value)) {
                boolean hasDot = s.indexOf('.') >= 0;
                boolean hasSlash = s.indexOf('/') >= 0;
                if (!(hasDot && hasSlash)) {
                    if (hasDot) {
                        return replaceHelper(s.replace('.', '/')).replace('/', '.');
                    } else {
                        return replaceHelper(s);
                    }
                }
            }
            if (verbose && !s.equals(value))
                System.err.println("Changed \"" + value + "\" -> \"" + s + "\"");
        }
        return s;
    }

    private String replaceHelper(String value) {
        for (Wildcard wildcard : wildcards) {
            String test = wildcard.replace(value);
            if (test != null)
                return test;
        }
        return value;
    }
}

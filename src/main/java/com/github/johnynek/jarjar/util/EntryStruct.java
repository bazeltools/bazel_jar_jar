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

package com.github.johnynek.jarjar.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class EntryStruct {
    private static final Pattern NAME_PARTS_PATTERN = Pattern.compile("((?:META-INF/versions/[1-9][0-9]*/)?)(.*)");

    public byte[] data;
    public String name;
    public long time;
    public boolean skipTransform;

    /**
     * Returns a version path prefix such as "META-INF/versions/9/" if the entry is a versioned
     * entry in a multi-release JAR, or an empty string otherise.
     */
    public String getVersionPrefix() {
        Matcher matcher = NAME_PARTS_PATTERN.matcher(name);
        matcher.matches();
        return matcher.group(1);
    }

    public String getClassName() {
        Matcher matcher = NAME_PARTS_PATTERN.matcher(name);
        matcher.matches();
        return matcher.group(2);
    }
}

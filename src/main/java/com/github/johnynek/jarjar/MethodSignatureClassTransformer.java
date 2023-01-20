package com.github.johnynek.jarjar;

import com.github.johnynek.jarjar.util.RemappingClassTransformer;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;
import org.objectweb.asm.commons.Remapper;

/**
 * Remaps string values representing method signatures to use the new package.
 *
 * <p>{@link PackageRemapper} is only able to remap string values which exactly match the package
 * being renamed. Method signatures are more difficult to detect so this class keeps track of which
 * methods definitely take method signatures and remaps those explicitly.
 */
public class MethodSignatureClassTransformer extends RemappingClassTransformer {

  /**
   * List of method names which take a method signature as their parameter.
   *
   * <p>Right now we assume all these methods take exactly one parameter and that it's a stirng.
   */
  private static final Set<String> METHOD_NAMES_WITH_PARAMS_TO_REWRITE =
      new HashSet<String>(Arrays.asList("getImplMethodSignature"));

  public MethodSignatureClassTransformer(Remapper remapper) {
    super(remapper);
  }

  @Override
  public MethodVisitor visitMethod(
      int access,
      java.lang.String name,
      java.lang.String descriptor,
      java.lang.String signature,
      java.lang.String[] exceptions) {
    return new MethodSignatureRemapperMethodVisitor(
        cv.visitMethod(access, name, descriptor, signature, exceptions));
  }

  private class MethodSignatureRemapperMethodVisitor extends MethodVisitor {

    // Whether to attempt to rewrite the next ldc instruction we see.
    // This will be safe because we will only look for methods that will always immediately take
    // a string.
    private boolean rewriteNextLdcInstruction = false;

    private MethodSignatureRemapperMethodVisitor(MethodVisitor methodVisitor) {
      super(Opcodes.ASM9, methodVisitor);
    }

    private boolean shouldMarkNextLdcForRewrite(int opcode, String name) {
      return opcode == Opcodes.INVOKEVIRTUAL && METHOD_NAMES_WITH_PARAMS_TO_REWRITE.contains(name);
    }

    @Override
    public void visitMethodInsn(int opcode, String owner, String name, String descriptor) {
      rewriteNextLdcInstruction = shouldMarkNextLdcForRewrite(opcode, name);
      mv.visitMethodInsn(opcode, owner, name, descriptor);
    }

    @Override
    public void visitMethodInsn(
        int opcode, String owner, String name, String descriptor, boolean isInterface) {
      rewriteNextLdcInstruction = shouldMarkNextLdcForRewrite(opcode, name);
      mv.visitMethodInsn(opcode, owner, name, descriptor, isInterface);
    }

    @Override
    public void visitLdcInsn(Object value) {
      if (rewriteNextLdcInstruction && value instanceof String) {
        rewriteNextLdcInstruction = false;
        mv.visitLdcInsn(remapper.mapSignature((String) value, false));
      } else {
        mv.visitLdcInsn(value);
      }
    }
  }
}

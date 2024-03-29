```@meta
EditURL="https://hirlam.org/trac//wiki//LSMIXandJk?action=edit"
```

# Jk as a pre-mixing method

The 3D-Var cost function including the Jk term can be written:
```bash
#!latex
\[
  J(x) = J_b + J_o + J_k = \frac{1}{2} (x - x_b)^{\rm T} B^{-1}(x - x_b)
         + \frac{1}{2} (y - Hx)^{\rm T}R^{-1}(y - Hx)
         + \frac{1}{2} (x - x_{LS})^{\rm T} V^{-1}(x - x_{LS}).
\]
```
Setting the gradient to zero, we have at the optimal x:
```bash
#!latex
\[
  \nabla J = B^{-1}(x - x_b) - H^{\rm T}R^{-1}(y - Hx) + V^{-1}(x - x_{LS}) = 0,
\]
```
or
```bash
#!latex
\[
  [B^{-1} + V^{-1} + H^{\rm T}R^{-1}H](x - x_b) = H^{\rm T}R^{-1}(y - Hx_b) + V^{-1}(x_{LS} - x_b).
\]
```
## Equivalent pre-mixed first guess
```bash
#!latex
Assume now that $\widetilde{x_b}$ is some yet unknown, pre-mixed field depending on $x_b$ and $x_{LS}$ that we want to determine.
```
By adding and subtracting identical terms to the gradient equation, we have
```bash
#!latex
\[
  B^{-1}(x - x_b + \widetilde{x_b} - \widetilde{x_b}) - H^{\rm T}R^{-1}(y - Hx + H\widetilde{x_b} - H\widetilde{x_b}) + V^{-1}(x - x_{LS} + \widetilde{x_b} - \widetilde{x_b}) = 0,
\]
```
which, when reorganized gives
```bash
#!latex
\[
  [B^{-1} + V^{-1} + H^{\rm T}R^{-1}H](x - \widetilde{x_b}) = H^{\rm T}R^{-1}(y - H\widetilde{x_b}) + B^{-1}(x_b - \widetilde{x_b}) + V^{-1}(x_{LS} - \widetilde{x_b}).
\]
```
If the last two terms on the right hand side add up to zero, i.e.,
```bash
#!latex
\[
  B^{-1}(x_b - \widetilde{x_b}) + V^{-1}(x_{LS} - \widetilde{x_b}) = 0,
\]
```
which means that
```bash
#!latex
\[
  \widetilde{x_b} = [B^{-1} + V^{-1}]^{-1} ( B^{-1} x_b + V^{-1} x_{LS} ),
\]
```
then we see that by using this mixed first guess the Jk term can be omitted, provided we use a modified B-matrix with the property that
```bash
#!latex
\[
  \widetilde{B}^{-1} = B^{-1} + V^{-1}.
\]
```
By writing
```bash
#!latex
\[
  B^{-1} + V^{-1} = B^{-1}(B + V)V^{-1} = V^{-1}(B + V)B^{-1}
\]
```
we easily see by simply inverting that
```bash
#!latex
\[
  \widetilde{B} = [B^{-1} + V^{-1}]^{-1} = B(B + V)^{-1}V = V(B + V)^{-1}B.
\]
```
To conclude, a 3D-Var minimization with Jk is equivalent to a minimization without the Jk term, provided that one pre-mixes the two first guess fields according to
```bash
#!latex
\[
  \widetilde{x_b} = [B^{-1} + V^{-1}]^{-1} ( B^{-1} x_b + V^{-1} x_{LS} ) = \widetilde{B}( B^{-1} x_b + V^{-1} x_{LS} ) = V(B + V)^{-1}x_b + B(B + V)^{-1}x_{LS}
\]
```
and use the following covariance matrix for this mixed first guess:
```bash
#!latex
\[
  \widetilde{B} = [B^{-1} + V^{-1}]^{-1} = B(B + V)^{-1}V = V(B + V)^{-1}B.
\]
```
Whether this is implementable in practice is a different story, it just shows the theoretical equivalence, and how LSMIXBC should ideally be done if Jk is the right answer.


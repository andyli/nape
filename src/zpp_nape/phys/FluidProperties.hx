package zpp_nape.phys;
import zpp_nape.Const;
import zpp_nape.util.Array2;
import zpp_nape.ID;
import zpp_nape.util.Circular;
import zpp_nape.util.DisjointSetForest;
import zpp_nape.util.Debug;
import zpp_nape.util.FastHash;
import zpp_nape.util.Flags;
import zpp_nape.util.Math;
import zpp_nape.util.Names;
import zpp_nape.util.Pool;
import zpp_nape.util.Queue;
import zpp_nape.util.RBTree;
import zpp_nape.util.UserData;
import zpp_nape.util.WrapLists;
import zpp_nape.util.Lists;
import zpp_nape.space.Broadphase;
import zpp_nape.space.DynAABBPhase;
import zpp_nape.space.SweepPhase;
import zpp_nape.shape.Circle;
import zpp_nape.shape.Edge;
import zpp_nape.shape.Polygon;
import zpp_nape.space.Space;
import zpp_nape.shape.Shape;
import zpp_nape.phys.Compound;
import zpp_nape.phys.FeatureMix;
import zpp_nape.phys.Body;
import zpp_nape.phys.Interactor;
import zpp_nape.phys.Material;
import zpp_nape.geom.AABB;
import zpp_nape.geom.Convex;
import zpp_nape.geom.ConvexRayResult;
import zpp_nape.geom.Cutter;
import zpp_nape.geom.Geom;
import zpp_nape.geom.GeomPoly;
import zpp_nape.geom.MarchingSquares;
import zpp_nape.geom.Collide;
import zpp_nape.geom.Mat23;
import zpp_nape.geom.MatMN;
import zpp_nape.geom.Monotone;
import zpp_nape.geom.PartitionedPoly;
import zpp_nape.geom.MatMath;
import zpp_nape.geom.PolyIter;
import zpp_nape.geom.Ray;
import zpp_nape.geom.Simple;
import zpp_nape.geom.Simplify;
import zpp_nape.geom.Triangular;
import zpp_nape.geom.Vec2;
import zpp_nape.geom.Vec3;
import zpp_nape.geom.SweepDistance;
import zpp_nape.geom.VecMath;
import zpp_nape.dynamics.Contact;
import zpp_nape.dynamics.InteractionFilter;
import zpp_nape.dynamics.InteractionGroup;
import zpp_nape.dynamics.SpaceArbiterList;
import zpp_nape.dynamics.Arbiter;
import zpp_nape.constraint.AngleJoint;
import zpp_nape.constraint.DistanceJoint;
import zpp_nape.constraint.Constraint;
import zpp_nape.constraint.LinearJoint;
import zpp_nape.constraint.MotorJoint;
import zpp_nape.constraint.LineJoint;
import zpp_nape.constraint.PivotJoint;
import zpp_nape.constraint.UserConstraint;
import zpp_nape.constraint.WeldJoint;
import zpp_nape.constraint.PulleyJoint;
import zpp_nape.callbacks.Callback;
import zpp_nape.callbacks.CbSetPair;
import zpp_nape.callbacks.CbType;
import zpp_nape.callbacks.CbSet;
import zpp_nape.callbacks.OptionType;
import nape.Config;
import nape.TArray;
import zpp_nape.callbacks.Listener;
import nape.util.BitmapDebug;
import nape.util.Debug;
import nape.space.Broadphase;
import nape.util.ShapeDebug;
import nape.shape.Circle;
import nape.shape.Edge;
import nape.shape.EdgeIterator;
import nape.shape.EdgeList;
import nape.space.Space;
import nape.shape.Polygon;
import nape.shape.ShapeIterator;
import nape.shape.ShapeList;
import nape.shape.ShapeType;
import nape.shape.Shape;
import nape.shape.ValidationResult;
import nape.phys.BodyIterator;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.CompoundIterator;
import nape.phys.CompoundList;
import nape.phys.FluidProperties;
import nape.phys.GravMassMode;
import nape.phys.InertiaMode;
import nape.phys.Interactor;
import nape.phys.InteractorIterator;
import nape.phys.InteractorList;
import nape.phys.MassMode;
import nape.phys.Material;
import nape.phys.Body;
import nape.geom.ConvexResult;
import nape.geom.ConvexResultIterator;
import nape.geom.ConvexResultList;
import nape.geom.Geom;
import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.GeomVertexIterator;
import nape.geom.IsoFunction;
import nape.geom.GeomPolyIterator;
import nape.geom.MarchingSquares;
import nape.geom.Mat23;
import nape.geom.MatMN;
import nape.geom.RayResult;
import nape.geom.RayResultIterator;
import nape.geom.RayResultList;
import nape.geom.Ray;
import nape.geom.Vec2Iterator;
import nape.geom.Vec2List;
import nape.geom.Vec3;
import nape.geom.Winding;
import nape.dynamics.Arbiter;
import nape.geom.Vec2;
import nape.dynamics.ArbiterIterator;
import nape.dynamics.ArbiterType;
import nape.dynamics.ArbiterList;
import nape.dynamics.CollisionArbiter;
import nape.dynamics.Contact;
import nape.dynamics.ContactIterator;
import nape.dynamics.ContactList;
import nape.dynamics.InteractionFilter;
import nape.dynamics.InteractionGroup;
import nape.dynamics.InteractionGroupIterator;
import nape.dynamics.InteractionGroupList;
import nape.dynamics.FluidArbiter;
import nape.constraint.AngleJoint;
import nape.constraint.ConstraintIterator;
import nape.constraint.ConstraintList;
import nape.constraint.Constraint;
import nape.constraint.DistanceJoint;
import nape.constraint.LinearJoint;
import nape.constraint.LineJoint;
import nape.constraint.PivotJoint;
import nape.constraint.PulleyJoint;
import nape.constraint.MotorJoint;
import nape.constraint.WeldJoint;
import nape.callbacks.BodyCallback;
import nape.callbacks.BodyListener;
import nape.callbacks.Callback;
import nape.constraint.UserConstraint;
import nape.callbacks.CbEvent;
import nape.callbacks.CbTypeIterator;
import nape.callbacks.CbTypeList;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.ConstraintListener;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.Listener;
import nape.callbacks.ListenerList;
import nape.callbacks.ListenerType;
import nape.callbacks.OptionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.callbacks.ListenerIterator;
#if nape_swc@:keep #end
class ZPP_FluidProperties{
    public var next:ZPP_FluidProperties=null;
    static public var zpp_pool:ZPP_FluidProperties=null;
    #if NAPE_POOL_STATS 
    /**
     * @private
     */
    static public var POOL_CNT:Int=0;
    /**
     * @private
     */
    static public var POOL_TOT:Int=0;
    /**
     * @private
     */
    static public var POOL_ADD:Int=0;
    /**
     * @private
     */
    static public var POOL_ADDNEW:Int=0;
    /**
     * @private
     */
    static public var POOL_SUB:Int=0;
    #end
    
    public var userData:Dynamic<Dynamic>=null;
    public var outer:FluidProperties=null;
    public function wrapper(){
        if(outer==null){
            outer=new FluidProperties();
            {
                var o=outer.zpp_inner;
                {
                    #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                    var res={
                        o!=null;
                    };
                    if(!res)throw "assert("+"o!=null"+") :: "+("Free(in T: "+"ZPP_FluidProperties"+", in obj: "+"outer.zpp_inner"+")");
                    #end
                };
                o.free();
                o.next=ZPP_FluidProperties.zpp_pool;
                ZPP_FluidProperties.zpp_pool=o;
                #if NAPE_POOL_STATS ZPP_FluidProperties.POOL_CNT++;
                ZPP_FluidProperties.POOL_SUB++;
                #end
            };
            outer.zpp_inner=this;
        }
        return outer;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function free(){
        outer=null;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function alloc(){}
    public var shapes:ZNPList_ZPP_Shape=null;
    public var wrap_shapes:ShapeList=null;
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function feature_cons(){
        shapes=new ZNPList_ZPP_Shape();
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function addShape(shape:ZPP_Shape){
        shapes.add(shape);
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function remShape(shape:ZPP_Shape){
        shapes.remove(shape);
    }
    public function copy(){
        var ret;
        {
            if(ZPP_FluidProperties.zpp_pool==null){
                ret=new ZPP_FluidProperties();
                #if NAPE_POOL_STATS ZPP_FluidProperties.POOL_TOT++;
                ZPP_FluidProperties.POOL_ADDNEW++;
                #end
            }
            else{
                ret=ZPP_FluidProperties.zpp_pool;
                ZPP_FluidProperties.zpp_pool=ret.next;
                ret.next=null;
                #if NAPE_POOL_STATS ZPP_FluidProperties.POOL_CNT--;
                ZPP_FluidProperties.POOL_ADD++;
                #end
            }
            ret.alloc();
        };
        ret.viscosity=viscosity;
        ret.density=density;
        return ret;
    }
    public function new(){
        feature_cons();
        density=viscosity=1;
        wrap_gravity=null;
        {
            gravityx=0;
            gravityy=0;
            {
                #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                var res={
                    !((gravityx!=gravityx));
                };
                if(!res)throw "assert("+"!assert_isNaN(gravityx)"+") :: "+("vec_set(in n: "+"gravity"+",in x: "+"0"+",in y: "+"0"+")");
                #end
            };
            {
                #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                var res={
                    !((gravityy!=gravityy));
                };
                if(!res)throw "assert("+"!assert_isNaN(gravityy)"+") :: "+("vec_set(in n: "+"gravity"+",in x: "+"0"+",in y: "+"0"+")");
                #end
            };
        };
    }
    public var viscosity:Float=0.0;
    public var density:Float=0.0;
    public var gravityx:Float=0.0;
    public var gravityy:Float=0.0;
    public var wrap_gravity:Vec2=null;
    private function gravity_invalidate(x:ZPP_Vec2){
        {
            gravityx=x.x;
            gravityy=x.y;
            {
                #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                var res={
                    !((gravityx!=gravityx));
                };
                if(!res)throw "assert("+"!assert_isNaN(gravityx)"+") :: "+("vec_set(in n: "+"gravity"+",in x: "+"x.x"+",in y: "+"x.y"+")");
                #end
            };
            {
                #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                var res={
                    !((gravityy!=gravityy));
                };
                if(!res)throw "assert("+"!assert_isNaN(gravityy)"+") :: "+("vec_set(in n: "+"gravity"+",in x: "+"x.x"+",in y: "+"x.y"+")");
                #end
            };
        };
        invalidate();
    }
    private function gravity_validate(){
        {
            wrap_gravity.zpp_inner.x=gravityx;
            wrap_gravity.zpp_inner.y=gravityy;
            {
                #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                var res={
                    !((wrap_gravity.zpp_inner.x!=wrap_gravity.zpp_inner.x));
                };
                if(!res)throw "assert("+"!assert_isNaN(wrap_gravity.zpp_inner.x)"+") :: "+("vec_set(in n: "+"wrap_gravity.zpp_inner."+",in x: "+"gravityx"+",in y: "+"gravityy"+")");
                #end
            };
            {
                #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                var res={
                    !((wrap_gravity.zpp_inner.y!=wrap_gravity.zpp_inner.y));
                };
                if(!res)throw "assert("+"!assert_isNaN(wrap_gravity.zpp_inner.y)"+") :: "+("vec_set(in n: "+"wrap_gravity.zpp_inner."+",in x: "+"gravityx"+",in y: "+"gravityy"+")");
                #end
            };
        };
    }
    public function getgravity(){
        wrap_gravity=Vec2.get(gravityx,gravityy);
        wrap_gravity.zpp_inner._inuse=true;
        wrap_gravity.zpp_inner._invalidate=gravity_invalidate;
        wrap_gravity.zpp_inner._validate=gravity_validate;
    }
    public function invalidate(){
        {
            var cx_ite=shapes.begin();
            while(cx_ite!=null){
                var shape=cx_ite.elem();
                shape.invalidate_fluidprops();
                cx_ite=cx_ite.next;
            }
        };
    }
}
